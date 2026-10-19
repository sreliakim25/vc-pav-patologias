"""
Copia projeto/kanban.json para dentro de painel/index.html (bloco de dados embutidos).

Assim o painel funciona mesmo aberto direto do arquivo, sem servidor.
Rode sempre depois de editar o kanban:

    python3 painel/embutir_dados.py

Opcional: gerar uma versão para publicar como página avulsa (sem as tags
<html>, <head> e <body>, que a plataforma de publicação já adiciona):

    python3 painel/embutir_dados.py --avulso caminho/saida.html
"""
import argparse
import json
import re
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
KANBAN = RAIZ / "projeto" / "kanban.json"
PAINEL = RAIZ / "painel" / "index.html"
MARCA_INICIO = "<!-- INICIO-DADOS -->"
MARCA_FIM = "<!-- FIM-DADOS -->"


def embutir() -> str:
    # valida o JSON antes de embutir: um kanban quebrado não deve chegar ao painel
    dados = json.loads(KANBAN.read_text(encoding="utf-8"))
    texto = json.dumps(dados, ensure_ascii=False, indent=1).replace("</", "<\\/")
    html = PAINEL.read_text(encoding="utf-8")
    padrao = re.compile(re.escape(MARCA_INICIO) + r".*?" + re.escape(MARCA_FIM), re.S)
    if not padrao.search(html):
        raise SystemExit("Marcadores de dados não encontrados em painel/index.html")
    html = padrao.sub(lambda _: f"{MARCA_INICIO}\n{texto}\n{MARCA_FIM}", html)
    PAINEL.write_text(html, encoding="utf-8")
    return html


def gerar_avulso(html: str, saida: Path) -> None:
    # remove o esqueleto do documento; a plataforma de publicação adiciona o seu
    for tag in [r"<!doctype html>", r"<html[^>]*>", r"</html>", r"<head>", r"</head>", r"<body>", r"</body>",
                r'<meta charset="utf-8">', r'<meta name="viewport"[^>]*>']:
        html = re.sub(tag, "", html, flags=re.I)
    saida.write_text(html.strip() + "\n", encoding="utf-8")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Embute o kanban.json no painel")
    parser.add_argument("--avulso", type=Path, help="gera também uma versão sem esqueleto HTML neste caminho")
    args = parser.parse_args()
    html = embutir()
    print(f"Dados embutidos em {PAINEL.relative_to(RAIZ)}")
    if args.avulso:
        gerar_avulso(html, args.avulso)
        print(f"Versão avulsa gerada em {args.avulso}")
