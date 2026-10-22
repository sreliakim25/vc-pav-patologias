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
# passos dos documentos de fase, usados na ficha de detalhes de cada tarefa
MARCA_PASSOS_INICIO = "<!-- INICIO-PASSOS -->"
MARCA_PASSOS_FIM = "<!-- FIM-PASSOS -->"
SECAO_ARTIGO = "## O que registrar para o artigo"


def extrair_passos(documento: Path) -> dict:
    """Lê um documento de fase e devolve {"1": {"titulo", "texto"}, ..., "artigo": {...}}."""
    passos = {}
    chave, titulo, linhas = None, "", []

    def fechar():
        if chave is not None:
            texto = "\n".join(linhas).strip()
            texto = re.sub(r"\n-{3,}\s*$", "", texto).strip()
            passos[chave] = {"titulo": titulo, "texto": texto}

    for linha in documento.read_text(encoding="utf-8").splitlines():
        passo = re.match(r"^### Passo (\d+)\.\s*(.*)$", linha)
        if passo:
            fechar()
            chave, titulo, linhas = passo.group(1), passo.group(2).strip(), []
        elif linha.strip() == SECAO_ARTIGO:
            fechar()
            chave, titulo, linhas = "artigo", "O que registrar para o artigo", []
        elif linha.startswith("## ") or linha.startswith("### "):
            # outro título encerra o passo atual
            fechar()
            chave, linhas = None, []
        elif chave is not None:
            linhas.append(linha)
    fechar()
    return passos


def substituir_bloco(html: str, inicio: str, fim: str, texto: str) -> str:
    padrao = re.compile(re.escape(inicio) + r".*?" + re.escape(fim), re.S)
    if not padrao.search(html):
        raise SystemExit(f"Marcadores {inicio} não encontrados em painel/index.html")
    return padrao.sub(lambda _: f"{inicio}\n{texto}\n{fim}", html)


def embutir() -> str:
    # valida o JSON antes de embutir: um kanban quebrado não deve chegar ao painel
    dados = json.loads(KANBAN.read_text(encoding="utf-8"))
    texto = json.dumps(dados, ensure_ascii=False, indent=1).replace("</", "<\\/")
    passos = {str(f["id"]): extrair_passos(RAIZ / f["documento"]) for f in dados["fases"] if (RAIZ / f["documento"]).exists()}
    texto_passos = json.dumps(passos, ensure_ascii=False).replace("</", "<\\/")
    html = PAINEL.read_text(encoding="utf-8")
    html = substituir_bloco(html, MARCA_INICIO, MARCA_FIM, texto)
    html = substituir_bloco(html, MARCA_PASSOS_INICIO, MARCA_PASSOS_FIM, texto_passos)
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
