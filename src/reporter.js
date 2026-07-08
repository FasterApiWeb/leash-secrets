/**
 * Finding Reporter (Single Responsibility: format output)
 *
 * Interface Segregation: exports separate functions for
 * different output needs (inline, full report, JSON).
 */

const SEVERITY_ICONS = {
  critical: '\x1b[31m🔴 CRITICAL\x1b[0m',
  warning: '\x1b[33m🟡 WARNING\x1b[0m',
  info: '\x1b[36mℹ️  INFO\x1b[0m',
};

const SEVERITY_ICONS_PLAIN = {
  critical: '🔴 CRITICAL',
  warning: '🟡 WARNING',
  info: 'ℹ️  INFO',
};

function formatFindings(findings, options = {}) {
  const { color = true, verbose = false } = options;
  const icons = color ? SEVERITY_ICONS : SEVERITY_ICONS_PLAIN;

  if (findings.length === 0) {
    return color
      ? '\x1b[32m✅ No secrets detected.\x1b[0m'
      : '✅ No secrets detected.';
  }

  const lines = [];
  const criticals = findings.filter(f => f.severity === 'critical');
  const warnings = findings.filter(f => f.severity === 'warning');
  const infos = findings.filter(f => f.severity === 'info');

  lines.push('');
  lines.push('🔍 LEASH SCAN RESULTS');
  lines.push('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  lines.push(`  🔴 Critical:  ${criticals.length}`);
  lines.push(`  🟡 Warning:   ${warnings.length}`);
  lines.push(`  ℹ️  Info:      ${infos.length}`);
  lines.push('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  lines.push('');

  for (const finding of findings) {
    lines.push(`  ${icons[finding.severity]}  ${finding.pattern.name}`);
    lines.push(`    File:    ${finding.file}:${finding.line}`);
    lines.push(`    Matched: ${finding.matched}`);
    lines.push(`    Fix:     ${finding.pattern.fix}`);
    if (verbose && finding.pattern.risk) {
      lines.push(`    Risk:    ${finding.pattern.risk}`);
    }
    if (verbose && finding.pattern.rotation_url) {
      lines.push(`    Rotate:  ${finding.pattern.rotation_url}`);
    }
    lines.push('');
  }

  return lines.join('\n');
}

function formatReport(findings, metadata = {}) {
  const { repoName = 'unknown', date = new Date().toISOString().split('T')[0] } = metadata;

  const criticals = findings.filter(f => f.severity === 'critical');
  const warnings = findings.filter(f => f.severity === 'warning');

  let score = 'A';
  if (criticals.length >= 3) score = 'F';
  else if (criticals.length >= 1) score = 'D';
  else if (warnings.length > 3) score = 'C';
  else if (warnings.length >= 1) score = 'B';

  const lines = [
    `# Leash Security Report`,
    ``,
    `| Field | Value |`,
    `|-------|-------|`,
    `| Repository | ${repoName} |`,
    `| Date | ${date} |`,
    `| Score | **${score}** |`,
    `| Critical | ${criticals.length} |`,
    `| Warning | ${warnings.length} |`,
    ``,
  ];

  if (findings.length > 0) {
    lines.push('## Findings');
    lines.push('');
    lines.push('| Severity | Type | File | Line | Fix |');
    lines.push('|----------|------|------|------|-----|');

    for (const f of findings) {
      const icon = f.severity === 'critical' ? '🔴' : f.severity === 'warning' ? '🟡' : 'ℹ️';
      lines.push(`| ${icon} | ${f.pattern.name} | \`${f.file}\` | ${f.line} | ${f.pattern.fix} |`);
    }
    lines.push('');
  }

  if (criticals.length > 0) {
    lines.push('## Rotation Checklist');
    lines.push('');
    for (const f of criticals) {
      const url = f.pattern.rotation_url || 'check provider dashboard';
      lines.push(`- [ ] **${f.pattern.name}** at \`${f.file}:${f.line}\` — ${url}`);
    }
    lines.push('');
  }

  return lines.join('\n');
}

function formatJSON(findings) {
  return JSON.stringify(findings.map(f => ({
    severity: f.severity,
    type: f.pattern.id,
    name: f.pattern.name,
    file: f.file,
    line: f.line,
    matched: f.matched,
    fix: f.pattern.fix,
    risk: f.pattern.risk,
    rotation_url: f.pattern.rotation_url || null,
  })), null, 2);
}

module.exports = { formatFindings, formatReport, formatJSON };
