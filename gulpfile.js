require('dotenv').config();

const del = require('del');
const { src, dest, series } = require('gulp');
const rooibosCli = require('rooibos-cli');
const rokuDeploy = require('roku-deploy');

const args = {
    host: process.env.ROKU_DEV_TARGET,
    username: process.env.ROKU_DEV_USERNAME,
    password: process.env.ROKU_DEV_PASSWORD,
    retainStagingFolder: true,
    rootDir: 'src/',
    files: [
        'source/**/*',
        'components/**/*',
        'images/**/*',
        'manifest'
    ],
};

async function cleanStaging() {
    await del('./out');
}

async function pressHomeButton() {
    await rokuDeploy.pressHomeButton(args.host, args.port);
}

async function deploy() {
    await rokuDeploy.deploy(args);
}

async function prepareRooibos() {
    let config = rooibosCli.createProcessorConfig({
        projectPath: "out/.roku-deploy-staging",
        outputPath: "source/tests/rooibos/",
        testsFilePattern: [
            "source/tests/*.spec.brs",
            "!**/rooibosDist.brs",
            "!**/rooibosFunctionMap.brs",
            "!**/TestsScene.brs"
        ]
    });
    let processor = new rooibosCli.RooibosProcessor(config);
    await processor.processFiles();
}

exports.deploy = series(pressHomeButton, cleanStaging, deploy)