# https://github.com/fish-shell/fish-shell/issues/4583
if status --is-interactive
    keychain --eval --quiet -Q id_rsa | source
end
