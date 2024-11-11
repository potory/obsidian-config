import { encrypt } from "npm:octagonal-wheels@0.1.16/encryption/encryption.js";

const uri_passphrase = `${Deno.env.get("PASSPHRASE")}`;


const URIBASE = "obsidian://setuplivesync?settings=";
async function main() {
    const conf = {
        "couchDB_URI": `${Deno.env.get("EXTERNAL_DB")}`,
        "couchDB_USER": `${Deno.env.get("USERNAME")}`,
        "couchDB_PASSWORD": `${Deno.env.get("PASSWORD")}`,
        "couchDB_DBNAME": `${Deno.env.get("DATABASE")}`,
        "syncOnStart": true,
        "gcDelay": 0,
        "periodicReplication": true,
        "syncOnFileOpen": true,
        "encrypt": true,
        "passphrase": `${Deno.env.get("PASSPHRASE")}`,
        "usePathObfuscation": true,
        "batchSave": true,
        "batch_size": 50,
        "batches_limit": 50,
        "useHistory": true,
        "disableRequestURI": true,
        "customChunkSize": 50,
        "syncAfterMerge": false,
        "concurrencyOfReadChunksOnline": 100,
        "minimumIntervalOfReadChunksOnline": 100,
    }
    const encryptedConf = encodeURIComponent(await encrypt(JSON.stringify(conf), uri_passphrase, false));
    const theURI = `${URIBASE}${encryptedConf}`;
    console.log("\nYour passphrase of Setup-URI is: ", uri_passphrase);
    console.log("This passphrase is never shown again, so please note it in a safe place.")
    console.log(theURI);
}
await main();