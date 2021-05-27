# https://github.com/fish-shell/fish-shell/issues/4583
if status --is-interactive
    keychain --eval --agents ssh --quiet -Q id_rsa | source
    keychain --eval --agents gpg --quiet --gpg2 -Q | source
end
