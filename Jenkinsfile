
pipeline {
  agent any
  environment {
    ID_CLIENT     = credentials('id_client')
    SECRET_CLIENT = credentials('secret_client')
    TENANT_ID     = credentials('tenant_id')
  }

  stages {
    stage('Paso para clonar el repositorio') {
      steps {
          git url: 'git remote add origin https://github.com/miguemi/iac_prueba.git' 
            echo "Descargado el repositorio de la IAC"
      }
    }

    stage('Paso para autenticarse con Azure'){
      steps {
          sh 'az login --service-principal -u $ID_CLIENT -p $SECRET_CLIENT -t $TENANT_ID '
            echo "Autenticado a azure con éxito"
        
      }
    }
    
      stage('Paso para desplegar la infraestructura'){
      steps{
         sh('terraform init')
            echo "Terraform init finalizado"
            sh('terraform plan')
            echo "Terraform plan finalizada"
        
          echo('Despplegando la infraestructura')
          sh('terraform apply -auto-approve')
          echo('La infreastructura se desplegó con éxito!')
        
      }
    }
      stage('Paso para destruir la infraestructura'){
      steps {
        sh('terraform destroy -auto-approve')
        echo "Infraestructura destruida con éxito"
        
      }
    }
  }
}