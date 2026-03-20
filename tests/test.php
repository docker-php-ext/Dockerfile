<?php

$extension = $argv[1];

$customExtensionName = [
    'opcache' => 'Zend OPcache',
];

$loadExtensionName = isset($customExtensionName[$extension]) ? $customExtensionName[$extension] : $extension;

if (!extension_loaded($loadExtensionName)) {
    echo sprintf('FAIL: Extension "%s" is not loaded.', $loadExtensionName).PHP_EOL;
    exit(1);
}

exit(0);
