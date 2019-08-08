pipeline {
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
                        
  
                                stage ('Ansible Play') {
                                        retry() {
                                                sh 'oc login https://openshiftnextgen.in.dst.ibm.com:8443 -u $OPENSHIFT_ID -p $OPENSHIFT_PASS --insecure-skip-tls-verify=true'
                                        }
                                        try {
                                        sh 'oc delete project liberty-redis-build'
                                    } catch (Exception e) {
                                        echo 'project does not exist'
                                    }
                                    try {
                                        sh 'oc delete project liberty-redis-dev'
                                    } catch (Exception e) {
                                        echo 'project does not exist'
                                    }
                                    try {
                                        sh 'oc delete project liberty-redis-stage'
                                    } catch (Exception e) {
                                        echo 'project does not exist'
                                    }
                                    try {
                                        sh 'oc delete project liberty-redis-prod'
                                    } catch (Exception e) {
                                        echo 'project does not exist'
                                    }
                                        sh 'sleep 60'
                                        sh 'rm -rf ansible_playbook_templates_java'
                                        echo 'Cloning repository'
                                        sh 'git clone https://github.com/ashutosh-ibm/ansible_playbook_templates_java.git'
                                        echo 'Install ansible galaxy'
                                        sh 'ansible-galaxy install -r ansible_playbook_templates_java/requirements.yml --roles-path=ansible_playbook_templates_java/galaxy'
                                        echo 'Applying Ansible playbooks for docker build and push'
                                        sh 'echo $SSH_KEY > id_rsa'
                                        sh 'ansible-playbook -i ansible_playbook_templates_java/.applier/ ansible_playbook_templates_java/galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml'
                                        sh 'oc project liberty-redis-build'
                                        sh 'oc create secret generic nextgen-ssh --from-file=ssh-privatekey=id_rsa --type=kubernetes.io/ssh-auth'
                                        sh 'oc label secret nextgen-ssh credential.sync.jenkins.openshift.io=true'
                                }
                         

                        }
                }
            }
        }
    }
}
