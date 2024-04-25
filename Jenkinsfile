pipeline {
    agent any

    stages {
        stage('Embedded Build') {
            steps {
                script {
                    def filteredEnv = [:]
                    env.each { key, value ->
                        if (key =~ /DEBUG|NODE_|ELECTRON_|YARN_|NPM_|CI|CIRCLE|TRAVIS_TAG|TRAVIS|TRAVIS_REPO_|TRAVIS_BUILD_|TRAVIS_BRANCH|TRAVIS_PULL_REQUEST_|APPVEYOR_|CSC_|GH_|GITHUB_|BT_|AWS_|STRIP|BUILD_/) {
                            filteredEnv[key] = value
                        }
                    }

                    def envFileContent = ''
                    filteredEnv.each { key, value ->
                        envFileContent += "${key}=${value}\n"
                    }

                    writeFile file: 'env-file.txt', text: envFileContent
                    
                    sh '''
                    docker run --rm -i \
                     --env-file env-file.txt \
                     --env ELECTRON_CACHE="/root/.cache/electron" \
                     --env ELECTRON_BUILDER_CACHE="/root/.cache/electron-builder" \
                     -v ${env.WORKSPACE}:/project \
                     -v ${env.WORKSPACE.substring(env.WORKSPACE.lastIndexOf('/') + 1)}-node-modules:/project/node_modules \
                     -v ~/.cache/electron:/root/.cache/electron \
                     -v ~/.cache/electron-builder:/root/.cache/electron-builder \
                     electronuserland/builder:wine
                    '''
                    sh 'yarn && yarn dist'
                }
            }
        }
    }
}
