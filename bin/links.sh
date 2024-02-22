#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

declare -a VALID_PACKAGES=()
VALID_PACKAGES+=('aaa')
VALID_PACKAGES+=('bng')
VALID_PACKAGES+=('dhcpl2relay')
VALID_PACKAGES+=('kafka')
VALID_PACKAGES+=('mcast')
VALID_PACKAGES+=('maclearner')
VALID_PACKAGES+=('olttopology')
VALID_PACKAGES+=('olt')
VALID_PACKAGES+=('sadis')
readonly VALID_PACKAGES

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function usage()
{
    cat <<EOH
Usage: $0
  --docs         docs.voltha.org
  --edit-docs    edit release notes in repo:voltha-docs

  --mvn-all      View all maven central artifacts
  --pkg [aaa|bng|kafka|maclearner|olt|olttopology|sadis]

  --nexus
  --todo
  --to-merge     View pending patches for artifact merge

[PUBLISH]
  --publish-maven    View jenkins job publish_{pkg}
EOH
}

##----------------##
##---]  MAIN  [---##
##----------------##
declare -a urls=()
declare -a to_edit=()

[[ $# -eq 0 ]] && { set -- '--default'; }

while [ $# -gt 0 ]; do
    arg="$1"; shift

    case "$arg" in

        --help) usage; exit 0 ;;

        --active)
            urls+=('https://gerrit.opencord.org/q/status:open+-is:wip%20')
            for repo in 'voltctl' 'bbsim' 'voltha-onos' 'voltha-openolt-adapter' 'voltha-docs' 'device-management-interface' 'voltha-release'; do
                #                urls+=('https://gerrit.opencord.org/q/status:open+-is:wip%20+%20voltha-onos')
                if true; then
                    echo "[SKIP] $repo"
                    continue
                fi
                # urls+=("https://gerrit.opencord.org/q/status:open+-is:wip%20+%20${repo}")
            done

            urls+=('https://gerrit.opencord.org/c/voltha-onos/+/34397')
            ;;
            
        --mvn-all)
            local pkg
            for pkg in "${VALID_PACKAGES[@]}";
            do
                urls+=("https://mvnrepository.com/search?q=${pkg}")
            done
            ;;
            
        --pkg)
            arg="$1"; shift
            pkg="${arg#"${arg%%[!-]*}"}"

            declare -a args=()
            args+=('--publish-maven' "$pkg")
            set -- "${args[@]}" "$@"
            
            urls+=("https://mvnrepository.com/search?q=${pkg}")
            urls+=("https://github.com/joey-onf/todo/tree/origin/master/release/${pkg}")

            # Docker
            urls+=("https://hub.docker.com/layers/voltha/${pkg}")
            
            # Golang
            urls+=("https://pkg.go.dev/github.com/opencord/${pkg}")

            # Jenkins
#            urls+=("https://jenkins.opencord.org/job/maven-publish_${pkg}")

            # Pypi
            urls+=("https://pypi.org/project/${pkg}")

            case "$pkg" in
                aaa)
	                urls+=('https://jenkins.opencord.org/job/onos-app-release/305/console')
                    ;;

                bng) ;;

                dhcpl2relay) ;;

                kafka*) ;;

                mcast)
                    urls+=('https://gerrit.opencord.org/c/mcast/+/34987')
                    ;;

                mac*) ;;

                ofagent-go)
                    urls+=('https://gerrit.opencord.org/c/ofagent-go/+/35012')
                    ;;

                olttopology)
                    urls+=('https://gerrit.opencord.org/c/olttopology/+/35007')
                    ;;                

                olt)
	                ulrs+=('https://jenkins.opencord.org/job/onos-app-release/304/console')
                    ;;

                sadis) ;;

                voltha-go)
                    urls+=('https://gerrit.opencord.org/c/voltha-go/+/34972')
                    ;;
                
                *) error "Detected invalid --pkg [$pkg]" ;;
            esac
            ;;

        --edit-docs)
            declare sandbox="$HOME/projects/sandbox"
            to_edit+=("$sandbox/voltha-docs/release_notes/voltha_2.12.rst")
            ;;

        --docs)
            # urls+=('https://docs.voltha.org')
            urls+=('https://docs.voltha.org/master/release_notes/voltha_2.12.html#id11')
            urls+=('https://docs.voltha.org/master/howto/code/release-bugfix.html')
            ;;

        ## Initiate publishing
        --jenkins)
            urls+=('https://jenkins.opencord.org/job/onos-app-release/')
            ;;
        
        --nexus)
            ## Publish onos components
            urls+=('https://oss.sonatype.org/#stagingRepositories')
            ;;

        --publish-maven)
            pkg="$1"; shift
            urls+=("https://jenkins.opencord.org/job/maven-publish_${pkg}")
            ;;
        
        --to-merge)
            # https://stackoverflow.com/questions/66958052/gerrit-query-command-with-multiple-numbers
            urls+=('https://gerrit.opencord.org/q/owner:do-not-reply%2540opennetworking.org')
            # urls+=('https://gerrit.opencord.org/q/owner:do-not-reply%2540opennetworking.org+is:open')
            urls+=('https://gerrit.opencord.org/q/owner:do-not-reply%2540opennetworking.org+is:open+-age:1mon')
           ;;

        
	    --todo)
	        urls+=('https://github.com/joey-onf/todo/blob/origin/master/release/release-meta.md')
            urls+=('https://github.com/joey-onf/todo/blob/origin/master/release/ONOS-component-deps.md')
	        ;;
        
        *)
            [[ -v seen ]] && { continue; }
            declare -i seen=1

            urls+=('https://jenkins.opencord.org/job/onos-app-release/')
            # urls+=('https://gerrit.opencord.org/c/infra-docs/+/34846')

            # urls+=('https://jenkins.opencord.org/job/verify_voltha-docker-tools_unit-test/48/console')

            ## ONOS: sadis job
            # urls+=('https://jenkins.opencord.org/job/onos-app-release/291/consoleText')
            # urls+=('https://jenkins.opencord.org/job/onos-app-release/')

            urls+=('https://gerrit.opencord.org/q/owner:do-not-reply%2540opennetworking.org')

            urls+=('https://mvnrepository.com/artifact/org.opencord')

            ## Publish onos components
            urls+=('https://oss.sonatype.org/#stagingRepositories')
            # urls+=('https://oss.sonatype.org/#stagingRepositories')
            ;;
    esac
done

if [[ ${#to_edit[@]} -gt 0 ]]; then
    emacs "${to_edit[@]}"
fi

if [[ ${#urls[@]} -gt 0 ]]; then
    opera "${urls[@]}" >/dev/null 2>/dev/null &
fi

# [EOF]
