pipeline {
    agent any
    stages {
        stage('Kubernetes cluster') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-kubernetes') {
					sh '''
                    if [ ! aws cloudformation describe-stacks --region us-west-2 --stack-name eksctl-EmaJarK8sCluster-cluster ] && [ ! aws cloudformation describe-stacks --region us-west-2 --stack-name eksctl-EmaJarK8sCluster-nodegroup-standard-workers ] ; then
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
                    else
                        echo "Stacks eksctl-EmaJarK8sCluster-cluster and eksctl-EmaJarK8sCluster-nodegroup-standard-workers already exist"
                    fi
					'''
				}
			}
		}

        stage('Configuration file cluster') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-kubernetes') {
					sh '''
						aws eks --region us-west-2 update-kubeconfig --name EmaJarK8sCluster
					'''
				}
			}
		}
    }
}