## 1. Kom igång med tester (Jest + TypeScript)

En steg för steg guide för att komma igång med Jest och den enklaste formen av testning

### Steg 1. Installera Jest

Kör i projektroten:

```bash
npm install --save-dev jest @types/jest ts-jest
```

Varför dessa:

- `jest` = själva test-runnern
- `@types/jest` = typdefinitioner för TypeScript
- `ts-jest` = gör att vi kan köra `.ts`-filer direkt i Jest

### Steg 2. Skapa Jest-konfiguration

Kör:

```bash
npx ts-jest config:init
```

Det skapar `jest.config.js` ungefär så här:

```js
/** @type {import('ts-jest').JestConfigWithTsJest} */
module.exports = {
	testEnvironment: "node",
	transform: {
		"^.+\\.tsx?$": ["ts-jest", {}],
	},
};
```

Det här säger: använd Node-miljö, och alla `.ts` / `.tsx` körs via ts-jest.

### Steg 3. Flytta ut något som går att testa

I exempelkoden har vi en funktion som beräknar “x sekunder sedan”. Vi gör den testbar:

Skapa `lib/utils.ts`:

```ts
export function getRelativeTime(dateString: string): string {
	const date = new Date(dateString);
	const now = new Date();
	const seconds = Math.floor((now.getTime() - date.getTime()) / 1000);

	if (seconds < 60) return `${seconds}s ago`;
	const minutes = Math.floor(seconds / 60);
	if (minutes < 60) return `${minutes}m ago`;
	const hours = Math.floor(minutes / 60);
	if (hours < 24) return `${hours}h ago`;
	const days = Math.floor(hours / 24);
	return `${days}d ago`;
}
```

I din komponent (`page.tsx` eller liknande):

```ts
import { getRelativeTime } from "@/lib/utils";
```

### Steg 4. Skriv ett test

Skapa `lib/utils.test.ts`:

```ts
import { getRelativeTime } from "./utils";

describe("getRelativeTime", () => {
	it("returns seconds ago for recent dates", () => {
		const now = new Date();
		const fiveSecondsAgo = new Date(now.getTime() - 5000).toISOString();
		const result = getRelativeTime(fiveSecondsAgo);

		expect(result).toBe("5s ago");
	});

	it("returns minutes ago for slightly older timestamps", () => {
		const now = new Date();
		const tenMinutesAgo = new Date(
			now.getTime() - 10 * 60 * 1000
		).toISOString();
		const result = getRelativeTime(tenMinutesAgo);

		expect(result).toBe("10m ago");
	});

	// Demo: ett test som ska faila så vi ser röd bock i CI
	it("intentionally fails so we can demo CI feedback", () => {
		const result = getRelativeTime(new Date().toISOString());
		// Det här kommer inte stämma, och det är meningen :)
		expect(result).toBe("now");
	});
});
```

Nu har du både ett grönt case och ett rött case.

### Steg 5. Lägg till testscript i `package.json`

I `package.json`, under `"scripts"`, lägg till:

```json
"scripts": {
  "lint": "next lint",
  "test": "jest"
}
```

Nu kan du köra lokalt:

```bash
npm test
```

Nästa steg är att få in detta i en Github Actions pipeline :)
Samt förstås att skriva fler och relevanta tester!
