# Exchange 2010 - 2016 - Exchange Online

# Como migrar usuarios a cloud

1) Ingresar a Server -> Abrir la consola de Exchange -> Buscar el pais o la persona a la cual se quiere migrar, en caso de ser un grupo de personas se puede exportar desde la consola de exchange.
2) Crear un archivo .CSV con Encoding UTF-8 (Excel trae la opcion nativa para grabar el archivo), con el siguiente nombre: "ExO_Precheck.csv" | Este debe contener dentro la columna A "DisplayName" y debajo todos los usuarios que se quieran revisar.
3) Como administrador ejecutar desde PowerShell -> ExchangeOnline_Pre_Precheck.ps1
4) Una vez que termina ejecutar -> ExchangeOnline_Precheck.ps1
