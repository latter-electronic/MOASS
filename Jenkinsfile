pipeline {
    agent any

    stages {
        stage('Embedded Build') {
            steps {
                dir('/var/jenkins_home/workspace/Moass/Embedded/electron-app') {
                    script {
                        def filteredEnv = env.findAll { key, value ->
                            key =~ /DEBUG|NODE_|ELECTRON_|YARN_|NPM_|CI|CIRCLE|TRAVIS_TAG|TRAVIS|TRAVIS_REPO_|TRAVIS_BUILD_|TRAVIS_BRANCH|TRAVIS_PULL_REQUEST_|APPVEYOR_|CSC_|GH_|GITHUB_|BT_|AWS_|STRIP|BUILD_/
                        }.collectEntries { key, value ->
                            [(key): value]
                        }

                        sh """
                        docker run --rm -ti \\
                         --env-file <(echo '${filteredEnv.join("\\n")}') \\
                         --env ELECTRON_CACHE="/root/.cache/electron" \\
                         --env ELECTRON_BUILDER_CACHE="/root/.cache/electron-builder" \\
                         -v ${env.WORKSPACE}:/project \\
                         -v ${env.WORKSPACE.substring(env.WORKSPACE.lastIndexOf('/') + 1)}-node-modules:/project/node_modules \\
                         -v ~/.cache/electron:/root/.cache/electron \\
                         -v ~/.cache/electron-builder:/root/.cache/electron-builder \\
                         electronuserland/builder:wine
                        """
                        sh 'yarn && yarn dist'
                    }
                }
            }
        }
    }
}