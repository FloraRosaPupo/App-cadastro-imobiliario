import pandas as pd
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Inicializar o aplicativo do Firebase
cred = credentials.Certificate(
    r'C:\Users\flora\OneDrive\Documentos\Aplicativo de Cadastro\projeto_prefeitura\app-de-cadastro-imobiliario-firebase-adminsdk-cbx4e-5399b5b3ed.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

# Definir o caminho para o arquivo CSV contendo os dados dos imóveis
caminho_arquivo = r'C:\Users\flora\OneDrive\Documentos\Aplicativo de Cadastro\projeto_prefeitura\teste.csv'

# Função para carregar os dados no Firestore


def carregar_dados_firestore(dados):
    # Percorrer cada registro
    for _, registro in dados.iterrows():
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
        # Ler os dados da planilha usando a biblioteca pandas
        dados_imoveis = pd.read_csv(caminho_arquivo)

        # Chamar a função para carregar os dados no Firestore
        carregar_dados_firestore(dados_imoveis)

        print('Importação concluída.')

    except FileNotFoundError:
        print(f"Arquivo não encontrado: {caminho_arquivo}")
    except Exception as e:
        print(f"Ocorreu um erro durante a importação: {str(e)}")


# Chamar a função principal para iniciar o processo de importação
if __name__ == '__main__':
    main()
