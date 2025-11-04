## 3. Aktivera Branch Protection / Branch Rules så att trasig kod inte kan mergeas

- Ingen får mergea in i `main` om testerna (Actions) är röda.
- (Bonus) Kräva pull request istället för att folk pushar direkt till `main`.

GitHub har två varianter för att skydda main idag:

- Klassiska “Branch protection rules”
- Nyare “Rulesets” (mer kraftfullt, särskilt i organisationer)

### Steg 1. Gå till Settings

1. Gå till ditt repo på GitHub.
2. Klicka på **Settings** (uppe i repo-fliken, bredvid “Actions”, “Security”, etc.).

### Steg 2. Gå till regler för branches

3. I vänstermenyn: klicka **Branches**.
4. Välj antingen "Add branch ruleset" eller "Add classic branch protection rule"

### Steg 3. Låt oss välja branch ruleset, då kommer vi till **Rules**

4. Ange ruleset name:
5. Slå på enforcement status till enabled
6. Sätt target branches till "default"

### Steg 4. Slå på skydd du vill ha (men exempelvis)

- **Require a pull request before merging**

  - Ingen får längre pusha direkt till `main`. Allt måste gå via PR.

- **Require status checks to pass before merging**

  - Du talar nu om: “PR:n måste ha gröna kontroller innan merge.”
    Status checks = t.ex. ditt “CI”-jobb i GitHub Actions. GitHub låter dig välja vilka checks som krävs. Efter att ett workflow har kört på repot, dyker det upp här som ett valbart krav.

  När du kryssar i detta får du (ungefär):

  - välj vilken check som är required (`namnet på ditt workflow`)
  - ev. “Require branches to be up to date before merging”
    (det betyder: PR-branchen måste vara uppdaterad med senaste `main` först — vanlig i större team där man vill undvika konfliktkod)

### Steg 5. Spara

5. Klicka **Create** / **Save changes**.

Klart.

Nu är flödet så här:

- Vi gör en feature-branch
- Pushar → Actions kör tester/linters
- Öppnar PR → Actions kör igen och rapporterar in i PR:n
- Om något är rött = GitHub visar PR:en som “Checks failing” och **Merge-knappen är spärrad**
- Om allt är grönt och review är godkänd = Merge allowed - TOPPEN!
