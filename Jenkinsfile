pipeline {
    agent any
    stages {
        stage('Kubernetes cluster') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-kubernetes') {
					sh '''
                    if [ ! aws cloudformation describe-stacks --region us-west-2 --stack-name eksctl-EmaJarK8sCluster-cluster ] ; then

                        if [ ! aws cloudformation describe-stacks --region us-west-2 --stack-name eksctl-EmaJarK8sCluster-nodegroup-standard-workers ] ; then
                            
                            eksctl create cluster \
                            --name EmaJarK8sCluster \
                            --version 1.13 \
                            --nodegroup-name standard-workers \
                            --node-type t2.small \
                            --nodes 2 \
                            --nodes-min 1 \
                            --nodes-max 3 \
                            --node-ami auto \
                            --region us-west-2 \
                            --zones us-west-2a \
                            --zones us-west-2b \
                            --zones us-west-2c \
                        
                        fi
                    
                    fi

                    which aws
                    aws --version
                    hostname
					'''
				}
			}
		}

        // stage('Configuration file cluster') {
		// 	steps {
		// 		withAWS(region:'us-west-2', credentials:'aws-kubernetes') {
		// 			sh '''
        //                 which aws
        //                 aws --version
        //                 hostname
		// 				aws eks --region us-west-2 update-kubeconfig --name EmaJarK8sCluster
		// 			'''
		// 		}
		// 	}
		// }


        stage('Lint HTML') {
			steps {
                sh 'pwd'
				sh 'tidy -q -e deploy/*.html'
			}
		}
		
		stage('Docker image build') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh '''
						docker build -f deploy/Dockerfile -t emajar/udacity_capstone .
					'''
				}
			}
		}

        stage('Docker image push') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh '''
						docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
						docker push emajar/udacity_capstone
					'''
				}
			}
		}

        stage('Set current kubectl context') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-kubernetes') {
					sh '''
                        kubectl config get-contexts
						kubectl config use-context EmaJarUser@EmaJarK8sCluster.us-west-2.eksctl.io
					'''
				}
			}
		}

        stage('Deploy blue container') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-kubernetes') {
					sh '''
                        kubectl config view
						kubectl apply -f ./deploy/blue-controller.json
					'''
				}
			}
		}

        stage('Deploy green container') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-kubernetes') {
					sh '''
						kubectl apply -f ./deploy/green-controller.json
					'''
				}
			}
		}

        stage('Create the service in the cluster, redirect to blue') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-kubernetes') {
					sh '''
						kubectl apply -f ./blue-service.json
					'''
				}
			}
		}

        stage('Wait user approve') {
            steps {
                input "Ready to redirect traffic to green?"
            }
        }

        stage('Create the service in the cluster, redirect to green') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-kubernetes') {
					sh '''
						kubectl apply -f ./green-service.json
					'''
				}
			}
		}
    }
}

