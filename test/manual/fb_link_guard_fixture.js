#!/usr/bin/env node
'use strict';

var guard = require('../../js/ckeditor_plugins/fb_link_guard/plugin.js');

var cases = [
    { href: '"https://first-base.co.uk/current-jobs"', valid: false },
    { href: '&quot;mailto:andrew.penrith@first-base.co.uk&quot;', valid: false },
    { href: 'http:/www.first-base.co.uk/current-jobs', valid: false },
    { href: 'https:/first-base.co.uk/current-jobs', valid: false },
    { href: '/job/example/http:/www.first-base.co.uk/current-jobs', valid: false },
    { href: 'javascript:alert(1)', valid: false },
    { href: '/current-jobs/', valid: true },
    { href: 'mailto:valid.person@first-base.co.uk', valid: true },
    { href: 'https://first-base.co.uk/job/administrator-6846-6846/"https://www.first-base.co.uk/terms-and-conditions"', valid: false },
    { href: 'https://first-base.co.uk/job/administrator-6846-6846/https:/www.first-base.co.uk/terms-and-conditions', valid: false },
    { href: 'https://first-base.co.uk/job/cost-analyst-6947-6947/"mailto:andrew.penrith@first-base.co.uk"', valid: false },
    { href: 'https://first-base.co.uk/job/cost-analyst-6947-6947/mailto:andrew.penrith@first-base.co.uk', valid: false },
    { href: 'https://first-base.co.uk/job/warehouse-supervisor-6944-6944/"https://first-base.co.uk/current-jobs?utm_source=chatgpt.com"', valid: false },
    { href: 'https://first-base.co.uk/job/administrator-6846-6846/', valid: true },
    { href: 'https://first-base.co.uk/wp-login.php?registration=disabled', valid: true }
];

var failures = cases.filter(function (testCase) {
    var issue = guard.getLinkIssue(testCase.href);
    var actualValid = issue === '';
    if (actualValid !== testCase.valid) {
        console.error('Expected ' + testCase.href + ' valid=' + testCase.valid + ' but got valid=' + actualValid + ' issue=' + issue);
        return true;
    }
    return false;
});

if (failures.length) {
    process.exit(1);
}

console.log('fb_link_guard fixture passed ' + cases.length + ' cases.');
