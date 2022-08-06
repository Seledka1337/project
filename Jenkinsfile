pipeline {
  agent any

  parameters {
    choice(
      name: 'ExecuteAction',
      choices: ['build', 'destroy'],
      description: 'Which action to take'
    )
  }

    stages {
      stage('Terraform init') {
        when { expression { params.ExecuteAction == 'build' } }
        steps {
          sh 'terraform init'
        }
      }

      stage('Terraform plan') {
        when { expression { params.ExecuteAction == 'build' } }
        steps {
          sh 'terraform plan'
        }
      }

      stage('Terraform apply') {
        when { expression { params.ExecuteAction == 'build' } }
        steps {
          sh 'terraform apply --auto-approve'
        }
      }

      stage('Terraform destroy') {
        when { expression { params.ExecuteAction == 'destroy' } }
        steps {
          sh 'terraform destroy --auto-approve'
        }
      }

      stage('Handle Terraforms output') {
        steps {
          sh './scripts/handle_output.sh'
        }
      }

      stage('Execute Ansible') {
        steps {
          dir('ansible') {
            sh 'ansible-playbook ./playbooks/wordpress.yml'
          }
        }
      }
    }
}
