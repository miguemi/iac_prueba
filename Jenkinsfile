pipeline {
  agent any
    stages {
      stage('Ejecutar') {
        steps {
          script {
            // Obtener la credencial secreta
            def secretCredential = credentials('test-hola-mundo')

              // Imprimir el valor de la credencial secreta
              echo "El valor de la credencial secreta es: ${secretCredential}"
          }
        }
      }
    }
}
