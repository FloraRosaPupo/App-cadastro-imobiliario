import gspread
from google.oauth2 import service_account
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Configurar as credenciais do Google Sheets
credenciais_sheets = service_account.Credentials.from_service_account_file(
    'caminho/para/arquivo-de-credenciais-sheets.json'
)

# Configurar as credenciais do Firestore
credenciais_firestore = credentials.Certificate(
    'caminho/para/arquivo-de-credenciais-firestore.json')

# Inicializar o aplicativo do Firebase
firebase_admin.initialize_app(credenciais_firestore)
db = firestore.client()

# Configurações da planilha do Google Sheets
nome_planilha = 'Nome da Planilha'
# Coloque os nomes das abas que deseja importar
nome_abas = ['Aba1', 'Aba2', 'Aba3']

# Função para carregar os dados no Firestore


def carregar_dados_firestore(dados):
    # Percorrer cada registro
    for registro in dados:
        # Extrair os dados do registro
        nome_proprietario = registro['Nome do proprietario']
        numero_imovel = registro['Numero do imovel']
        # ...

        # Criar um novo documento na coleção 'imoveis'
        novo_documento = db.collection('imoveis').document()

        # Definir os campos do documento
        novo_documento.set({
            'Nome do proprietario': nome_proprietario,
            'Numero do imovel': numero_imovel,
            # (Definir os outros campos conforme necessário)
        })

        print('Imóvel adicionado:', novo_documento.id)

# Função principal para carregar os dados da planilha


def main():
    try:
        # Abrir a planilha do Google Sheets
        cliente_sheets = gspread.authorize(credenciais_sheets)
        planilha = cliente_sheets.open(nome_planilha)

        # Percorrer cada aba e carregar os dados
        for aba in nome_abas:
            # Obter os dados da aba
            dados_aba = planilha.worksheet(aba).get_all_records()

            # Chamar a função para carregar os dados no Firestore
            carregar_dados_firestore(dados_aba)

        print('Importação concluída.')

    except Exception as e:
        print(f"Ocorreu um erro durante a importação: {str(e)}")


# Chamar a função principal para iniciar o processo de importação
if __name__ == '__main__':
    main()
