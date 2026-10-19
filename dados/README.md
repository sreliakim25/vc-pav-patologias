# dados/

Pasta local de dados. **O conteúdo não vai para o Git** (veja `.gitignore`); apenas este arquivo é versionado.

## Estrutura

```text
dados/
├── brutos/                         # o que sai da câmera, sem alteração
│   └── 2026-11-05_rua-exemplo_C1_p01/
│       ├── video.mp4
│       └── telemetria.gpx
├── quadros/                        # quadros extraídos e filtrados (nitidez, duplicatas)
│   └── 2026-11-05_rua-exemplo_C1_p01/
├── anonimizados/                   # quadros com rostos e placas desfocados (únicos que sobem)
├── vistoria/                       # planilha e fotos da medição de campo
│   ├── vistoria.csv
│   └── fotos/
└── datasets/                       # versões rotuladas e divididas
    ├── v1/
    │   ├── treino/
    │   ├── validacao/
    │   ├── teste/
    │   └── LEIAME.md               # contagem por classe, regras, data
    └── v1.1/
```

## Padrão de nome das pastas de coleta

`AAAA-MM-DD_<rua>_<configuracao>_<passada>`

- `<rua>`: nome curto, sem acento e sem espaço (ex.: `rua-joao-pessoa`).
- `<configuracao>`: `C1` câmera apontada para o pavimento, `C2` celular no para-brisa, `C3` celular de mão, `C4` drone.
- `<passada>`: `p01`, `p02`...

## Regra de ouro

Nada sai desta pasta para a nuvem ou para publicação sem passar por `anonimizados/`.
