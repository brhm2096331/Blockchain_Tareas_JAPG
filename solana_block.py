import sys
import json
import requests

# Endpoint público de la mainnet de Solana
URL = "https://api.mainnet-beta.solana.com"


def descargar_bloque(numero):
    # petición JSON-RPC para pedir el bloque
    datos = {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "getBlock",
        "params": [
            numero,
            {
                "encoding": "json",
                "transactionDetails": "full",
                "maxSupportedTransactionVersion": 1
            }
        ]
    }

    respuesta = requests.post(URL, json=datos, timeout=60)
    resultado = respuesta.json()

    # Si la API regresa error se mustra
    if "error" in resultado:
        print("Error de la API:", resultado["error"]["message"])
        return None

    return resultado["result"]


def main():
    # Revisar el numero de bloque (solo is lo pasa)
    if len(sys.argv) != 2:
        print("Uso: python solana_block.py <numero_de_bloque>")
        return

    try:
        numero = int(sys.argv[1])
    except ValueError:
        print("El número de bloque debe ser un entero")
        return

    bloque = descargar_bloque(numero)
    if bloque is None:
        return

    nombre_archivo = "bloque_" + str(numero) + ".json"
    with open(nombre_archivo, "w") as archivo:
        json.dump(bloque, archivo, indent=4)

    print("Listo, el bloque se guardó en", nombre_archivo)


if __name__ == "__main__":
    main()