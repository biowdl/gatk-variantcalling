pipeline {
    agent {
        node {
            label 'local'
        }
    }
    parameters {
        string name: 'PYTHON', defaultValue: '${DEFAULT}'
        string name: 'CROMWELL_BIN', defaultValue: '${DEFAULT}'
        string name: 'THREADS', defaultValue: '${DEFAULT}'
        string name: 'OUTPUT_DIR', defaultValue: '${DEFAULT}'
        string name: 'TAGS', defaultValue: '${DEFAULT}'
    }
    stages {
        stage('Init') {
            steps {
                script {
                    params.each { key, value ->
                        if (value == '${DEFAULT}') {
                            configFileProvider([configFile(fileId: key, variable: 'FILE')]) {
                                script {
                                    env.('' + key)=sh(returnStdout: true, script: 'cat $FILE')
                                }
                            }
                        }
                        sh('echo ' + key + '=$' + key)
                    }
                }
                checkout scm
                sh 'git submodule update --init --recursive'
                script {
                    env.outputDir= "${env.OUTPUT_DIR}/${env.JOB_NAME}/${env.BUILD_NUMBER}"
                }
                sh "rm -rf ${outputDir}"
                sh "mkdir -p ${outputDir}"
            }
        }

        stage('lint') {
            steps {
                sh 'bash scripts/biowdl_lint.sh'
            }
        }

        stage('Submodules develop') {
            when {
                branch 'develop'
            }
            steps {
                sh 'git submodule foreach --recursive git checkout develop'
                sh 'git submodule foreach --recursive git pull'
            }
        }

        stage('Build & Test') {
            steps {
                sh "#!/bin/bash\n" +
                        "set -e -v  -o pipefail\n" +
                        "export PATH=$PATH:$CROMWELL_BIN\n" +
                        "${PYTHON} -m pytest -v --keep-workflow-wd --workflow-threads ${THREADS} --basetemp ${outputDir} ${TAGS} tests/"
            }
        }
    }
}