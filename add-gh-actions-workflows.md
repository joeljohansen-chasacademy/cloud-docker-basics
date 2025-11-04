## 2. Skapa din första GitHub Action (CI-workflow)

Varje gång vi pushar kod eller öppnar en pull request vill vi att GitHub ska:

1. installera dependencies
2. köra lint
3. köra tester
4. markera PR som grön/röd

Dokumentation finns [här](https://docs.github.com/en/actions)

### Steg 1. Skapa mappen för workflows

Skapa filstrukturen om den inte redan finns:

```bash
mkdir -p .github/workflows
```

### Steg 2. Lägg till workflowfilen

Skapa `.github/workflows/main.yml` (namnet kan vara vad som helst, `main.yml` eller `ci.yml` spelar ingen roll).

### Alternativt steg 1 och 2. Skapa workflowet på Github

1. Gå till ditt repo på github.com
2. Klicka på "Actions"
3. Välj "Setup a workflow yourself"

### Skriv följande i editorn eller .yml filen du skapade i tidigare steg.

Innehåll:

```yaml
name: CI

on:
  push: #här skulle vi kunna ange specifika branches läs mer här: https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax#using-filters
  pull_request:

jobs:
  lint-and-test:
    runs-on: ubuntu-latest

    steps:
      # 1. Klona repot in i GitHub Actions-runnern
      - uses: actions/checkout@v4

      # 2. Installera rätt Node-version i den här maskinen
      - uses: actions/setup-node@v4
        with:
          node-version: 20

      # 3. Installera dependencies exakt som i lockfilen
      - run: npm ci

      # 4. Kör lintern (Next.js har next lint inbyggt)
      - run: npm run lint

      # 5. Kör testerna (inkl. det som failar)
      - run: npm test
```

Varje push → Actions-fliken i GitHub får en ny körning.
Varje PR → PR-sidan får en “Checks”-sektion där du ser om allt har gått bra eller ej.

Det här är Continuous Integration i ett nötskal!!

### Steg 3. Push

Gör commit och push/pull:

```bash
git add .
git commit -m "Add CI workflow with lint and tests"
git push
```

Kolla:

- Fliken **Actions** på GitHub: du ska se “CI” köra
- Din PR: du ska se statusen under “Checks”

Bra att göra en branch med failande test för att visa röd bock, och sedan fixa testet och pusha igen för att visa grön bock.
