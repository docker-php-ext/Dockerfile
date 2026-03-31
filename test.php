<?php

$extension = $argv[1];

$customExtensionName = [
    'opcache' => ['Zend OPcache'],
    'datadog' => ['ddtrace', 'datadog-profiling', 'ddappsec'],
    'elastic-apm' => ['elastic_apm'],
];

$loadExtensionName = isset($customExtensionName[$extension]) ? $customExtensionName[$extension] : [$extension];

foreach ($loadExtensionName as $name) {
    if (!extension_loaded($name)) {
        echo sprintf('❌ FAIL: Extension "%s" is not loaded.', $name).PHP_EOL;
        exit(1);
    } else {
        echo sprintf('✅ Extension "%s" is loaded.', $name).PHP_EOL;
    }
}

exit(0);
