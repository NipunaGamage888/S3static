pipeline{
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        S3_BUCKET = 'my-static-site-nipuna-18a34bf3'
    }

    triggers{
        githubPush()
    }

    stages{
        stage('clone repo'){
            steps{
                git credentialsId:'Staticq',
                url:'https://github.com/NipunaGamage888/S3static.git',
                branch:'main'
            }
        }
        stage('Deploy to S3'){
            steps{
                withAWS(credentials:'aws-credit', region:"${AWS_REGION}"){
                    sh """
                        aws s3 sync . s3://${S3_BUCKET} --delete  --delete --exclude '.git/*' --exclude 'Jenkinsfile'
                    """
                }
            }
        }
    }
}