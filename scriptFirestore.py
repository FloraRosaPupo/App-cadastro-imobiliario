import gspread
from google.oauth2 import service_account
import firebase_admin
from firebase_admin import credentials, firestore

# Caminho para o arquivo JSON da chave de serviço do Firebase
firebase_credentials_path = r'C:\Users\flora\OneDrive\Documentos\Aplicativo de Cadastro\projeto_prefeitura\app-de-cadastro-imobiliario-firebase-adminsdk-cbx4e-8803d80bff.json'

# Email da conta de serviço do Google Sheets
google_sheets_email = 'firebase-adminsdk-cbx4e@app-de-cadastro-imobiliario.iam.gserviceaccount.com'

# ID da planilha do Google Sheets
spreadsheet_id = '1uSK1R1QG1fKvjNjdDwnuzSA9vliDxtpAFQLAdLKRlEc'

# Intervalo de células da planilha que deseja importar
range_name = 'Pagina!A1:AA1'  # Exemplo de intervalo de células

# Configurar as credenciais do Firebase
firebase_credentials = credentials.Certificate(firebase_credentials_path)
firebase_admin.initialize_app(firebase_credentials)

# Configurar as credenciais do Google Sheets
google_credentials = service_account.Credentials.from_service_account_info(
    {
        'type': 'service_account',
        'project_id': 'seu_project_id',
        'private_key_id': '108762943338431382138',
        'private_key': 'firebase-adminsdk-cbx4e@app-de-cadastro-imobiliario.iam.gserviceaccount.com',  # pode dar erro
        'client_email': google_sheets_email,
        'client_id': '108762943338431382138',
        'auth_uri': 'https://accounts.google.com/o/oauth2/auth',
        'token_uri': 'https://accounts.google.com/o/oauth2/token',
        'auth_provider_x509_cert_url': 'https://www.googleapis.com/oauth2/v1/certs',
        'client_x509_cert_url': 'seu_client_x509_cert_url'
    }
)

# Ler os dados do Google Sheets e atualizar o Firebase


def read_data_from_google_sheets():
    gc = gspread.authorize(google_credentials)
    sheet = gc.open_by_key(spreadsheet_id).worksheet(range_name)
    values = sheet.get_all_values()

    if len(values) > 1:
        headers = values[0]
        records = [dict(zip(headers, row)) for row in values[1:]]

        # Atualizar o Firebase com os dados
        db = firestore.client()
        collection_ref = db.collection('imoveis')
        for record in records:
            collection_ref.add(record)


read_data_from_google_sheets()
print('Dados importados com sucesso para o Firebase')
