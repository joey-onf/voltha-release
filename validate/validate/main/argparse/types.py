# -*- python -*-

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##-------------------##
##---]  IMPORTS  [---##
##-------------------##
# import argparse
from argparse import ArgumentTypeError
import validators
# import semantic_version
import semver

from pathlib           import Path
from validators        import ValidationFailure

# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
def argparse_valid_version(value: str) -> bool:
    '''Validate a version string.'''

    # print(re.split('[-+#]', s_marks))
    fields = value.split('.')
    if 2 > len(fields):
        raise ValueError("{major}.{minor} are required")

    for idx in range(0,1):
        if not int(fields[idx]):
            raise ValueError("Detected non-numeric value %s in %s" % (fields[idx], value))

    return True

# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
def valid_version(value: str) -> str:
    '''Validate a version string.'''

    raw = value.strip()
    count = raw.count('.')

#    for idx in range(count, 3):
#        value += '.0'

    try:
        argparse_valid_version(value)
        # value = '1.2.3-pre.2+build.4'
        # semantic_version.Version(value)
        # semver.VersionInfo.parse(value)
    except ValueError as err:
        msg = 'Version string is invalid: %s' % raw
        raise ArgumentTypeError(msg)
    else:
        pass
    finally:
        pass

    return value

# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
def valid_url(value: str) -> str:
    """Custom argparse type for URL validation."""

    value = value.strip()
    is_url = validators.url(value)
    if isinstance(is_url, ValidationFailure):
        msg = 'URL string is invalid: %s' % value
        raise ArgumentTypeError(msg)

    return value

# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
def valid_spreadsheet(value: str) -> str:
    '''Custom argparse type for output spreadsheet validation.

    :param value: Command line argument value to check (--spread-out)
    :type  value: str

    :return: Path to a creatable spreadsheet file.
    :rtype:  str
    '''

    value = value.strip()

    if not value.endswith('.ods'):
        path = Path(value).my_file_with_suffix('.ods') # ods, xlsx
        value = path.as_posix()

    if Path(value).exists():
        msg = 'Detected invalid spreadsheet: %s' % (value)
        raise ArgumentTypeError(msg)

    return value

# [EOF]
