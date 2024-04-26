pipeline {
    agent any

    stages {
        stage('Embedded Build') {
	        steps {
				dir('/var/jenkins_home/workspace/Moass/Embedded/electron-app') {
                    // sh '''
                    // docker run --rm -i electronuserland/builder:wine /bin/bash -c "yarn && yarn dist -w"
                    // '''
                    // sh 'yarn && yarn dist'
                    sh 'docker build -t embedded .'
                }
            }
        }
    }
}
