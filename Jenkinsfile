pipeline {
    tools { 
        maven 'maven' 
        jdk 'JDK' 
    }
    agent {
        node {
            label 'docker-io-ui'
        }
    }
      environment {
        jenkins_openshift_username="c8fdb02e-71cf-4907-963d-19203ee74bb0"
        jenkins_openshift_password="68ec65fb-b20e-4f37-bf26-191bb85d6757"
      }

    options { skipDefaultCheckout() }

    stages {
        stage ('Initialize Application Migration') {
            agent none
            steps {
                script {
                        withCredentials(
                                        [string(credentialsId: jenkins_openshift_username, variable: 'OPENSHIFT_ID'),
                                        string(credentialsId: jenkins_openshift_password, variable: 'OPENSHIFT_PASS')])
                           {
                                stage ('Checkout') {
                                        echo 'Checking out SCM'
                                        checkout scm

                                        sh '''
                                                echo "PATH = ${PATH}"
                                                echo "M2_HOME = ${M2_HOME}"
                                        '''
                                }

                                stage ('Java Build') {
                                        
  
                                             echo 'Build'
                                             sh 'cd . && mvn clean install'
                                }
                                stage ('Docker Build') {
                                        retry() {
                                                sh 'oc login https://openshiftnextgen.in.dst.ibm.com:8443 -u $OPENSHIFT_ID -p $OPENSHIFT_PASS --insecure-skip-tls-verify=true'
                                        }
                                        echo 'creating project for build'
                                        sh 'oc new-project liberty-redis-build || oc project liberty-redis-build'
                                        echo 'Building and pushing image.'  
                                        sh 'oc delete is liberty-redis --ignore-not-found=true && oc delete bc liberty-redis --ignore-not-found=true && sleep 5 && oc new-build --binary=true --name liberty-redis && oc start-build --follow --from-dir . liberty-redis'
                                        echo 'Pushing image tagged :${env.BUILD_ID}.'
                                }
                                
                                stage ('Openshift deploy') {
                                        echo 'creating project for deployment'
                                        sh 'oc new-project liberty-redis-deploy || oc project liberty-redis-deploy'
                                        sh 'oc policy add-role-to-user  system:image-puller system:serviceaccount:liberty-redis-deploy:default --namespace=liberty-redis-build'
                                        echo 'deleting the previous deployment objects if exists'
                                        sh 'oc delete dc liberty-redis --ignore-not-found=true'
                                        sh 'oc delete is liberty-redis --ignore-not-found=true'
                                        sh 'oc delete svc liberty-redis --ignore-not-found=true'
                                        sh 'oc delete route liberty-redis --ignore-not-found=true'
                                        sh 'sleep 5'
                                        sh 'oc new-app liberty-redis-build/liberty-redis'
                                        sh 'oc delete svc liberty-redis --ignore-not-found=true'
                                        echo 'deleting the previous service if exists'
                                        sh 'sleep 3'
                                        sh 'oc expose dc liberty-redis --type=LoadBalancer'
                                        sh 'oc expose service/liberty-redis'
                                }
                                        
                        }
                }
            }
        }
    }
}
