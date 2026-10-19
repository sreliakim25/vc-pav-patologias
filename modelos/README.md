# modelos/

Pasta local de pesos treinados. **O conteúdo não vai para o Git.** Os pesos finais de cada versão publicada ficam no Hugging Face ou no Zenodo, com link registrado em `docs/artigo/diario-de-pesquisa.md`.

## Padrão de nome

`<tarefa>_<arquitetura>_<dataset>_<data>.<ext>`

Exemplos:

- `defeitos_yolo11s-seg_v1_2026-12-10.pt`
- `grade_segformer-b0_v1_2026-12-12.pt`
- `defeitos_rfdetr-seg_v1.1_2027-01-08.onnx`

## Cada peso precisa de um registro

Ao salvar um peso que será usado, registre no diário de pesquisa: versão do dataset, parâmetros, métricas no conjunto de teste fixo e o commit do código usado.
