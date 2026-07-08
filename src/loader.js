/**
 * Pattern Loader (Single Responsibility: load and validate patterns)
 *
 * Open/Closed: supports loading from the built-in library, custom files,
 * or remote URLs — all without modifying this module.
 */

const fs = require('fs');
const path = require('path');

const PATTERNS_DIR = path.join(__dirname, '..', 'patterns');

function parseRegex(pattern) {
  let regexStr = pattern.regex;
  let flags = '';
  if (regexStr.startsWith('(?i)')) {
    regexStr = regexStr.slice(4);
    flags = 'i';
  }
  return new RegExp(regexStr, flags);
}

function loadPatterns(options = {}) {
  const {
    patternsDir = PATTERNS_DIR,
    severities = ['critical', 'warning', 'info'],
    providers = null,
  } = options;

  const indexPath = path.join(patternsDir, 'index.json');
  if (!fs.existsSync(indexPath)) {
    throw new Error(`Pattern index not found: ${indexPath}`);
  }

  const index = JSON.parse(fs.readFileSync(indexPath, 'utf-8'));
  const patterns = [];

  for (const file of index.pattern_files) {
    const filePath = path.join(patternsDir, file);
    if (!fs.existsSync(filePath)) continue;

    const data = JSON.parse(fs.readFileSync(filePath, 'utf-8'));

    if (providers && !providers.includes(data.provider)) continue;

    for (const p of data.patterns) {
      if (!severities.includes(p.severity)) continue;

      patterns.push({
        ...p,
        provider: data.provider,
        providerName: data.display_name,
        compiledRegex: parseRegex(p),
      });
    }
  }

  return patterns;
}

function loadPatternsFromFile(filePath) {
  if (!fs.existsSync(filePath)) {
    throw new Error(`Pattern file not found: ${filePath}`);
  }

  const data = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
  return data.patterns.map(p => ({
    ...p,
    provider: data.provider,
    providerName: data.display_name,
    compiledRegex: parseRegex(p),
  }));
}

module.exports = { loadPatterns, loadPatternsFromFile };
