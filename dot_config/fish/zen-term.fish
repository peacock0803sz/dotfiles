# ZenTerm + zmx 連携 (tmux からの移行用)。config.fish から source する

# ZenTerm {{{
# ghostty/base.config の term = "xterm-256color" と tmux の default-terminal 相当。
# ZenTerm には TERM の設定項目が無いので、ペインのシェル側で上書きする (ZEN_PANE は ZenTerm のペインにだけある)
if set -q ZEN_PANE; and test "$TERM" = xterm-ghostty
    set --global --export TERM xterm-256color
end
# }}}

# zmx {{{
if type -q zmx
    # ctrl+\ は skkeleton の切り替え (Karabiner で ctrl+space から変換) に使うので、zmx の detach キーを無効にする。
    # detach はペインを閉じるか `zmx detach` で行う。attach する側のプロセスで読まれるので export しておく
    set --global --export ZMX_NO_DETACH_KEY 1

    # 既定の追跡対象に、ZenTerm がペインごとに渡す変数を足す。
    # 別のペインから attach し直しても zen CLI や zen-navigator.nvim が今のペインを指すよう、プロンプトごとに取り込み直す
    set --global --export ZMX_TRACK_ENV DISPLAY,SSH_AUTH_SOCK,SSH_AGENT_PID,SSH_CONNECTION,ZEN_PANE,ZEN_SOCK,ZEN_CONTROL_SOCK

    function _zmx_env_hook --on-event fish_prompt
        set -q ZMX_SESSION; or return
        for line in (zmx print-env .)
            if string match -q -- '-*' $line
                set --erase (string sub --start 2 -- $line)
            else
                set --global --export (string split --max 1 = -- $line)
            end
        end
    end

    # ZenTerm の workspaces から呼ぶ。ディレクトリと役割名から決めたセッションへ attach する (無ければ作る)。
    # worktree はディレクトリが違うので別のセッションになる
    #   zmx-pane <role> [command...]
    function zmx-pane --description 'Attach to the zmx session for this directory and role'
        if not set -q argv[1]
            echo 'usage: zmx-pane <role> [command...]' >&2
            return 2
        end
        set --local dir (path resolve $PWD)
        set --local name (path basename (path dirname $dir))-(path basename $dir).$argv[1]
        set name (string replace --all --regex -- '[^A-Za-z0-9._-]' _ $name)
        if set -q argv[2]
            # zmx はコマンドを直接 exec するので、fish の関数 (aibo など) も起動できるよう fish を挟む。
            # コマンドはセッションを新しく作るときだけ使われ、既存なら attach し直すだけ
            zmx attach $name (status fish-path) -l -i -c (string escape -- $argv[2..] | string join ' ')
        else
            # コマンドなしで作るセッションは $SHELL で起動されるので、GUI の環境に何が入っていても fish にする
            SHELL=(status fish-path) zmx attach $name
        end
    end

    # tmux attach -t / choose-session 相当。fzf で既存のセッションを選んで attach する。
    # zmx の中で実行すると、ネストせずに今のクライアントをそのセッションへ切り替える (switch-client 相当)。
    # 一致しない名前を入力して Enter、または Ctrl-N で、その名前のセッションを新しく作る
    function zmx-select --description 'Pick a zmx session with fzf and attach'
        set --local out (zmx list --short 2>/dev/null | fzf \
            --print-query --expect=ctrl-n --reverse --height=80% \
            --prompt='zmx> ' --header='Enter: attach | Ctrl-N: create new' \
            --preview='zmx history {}' --preview-window=right:60%:follow)
        set --local rc $status
        # Esc / Ctrl-C で抜けたときは何もしない
        test $rc -eq 130; and return 130
        set --local query $out[1]
        set --local key $out[2]
        set --local selected $out[3]
        set --local name
        if test "$key" = ctrl-n -a -n "$query"
            set name $query
        else if test $rc -eq 0 -a -n "$selected"
            set name $selected
        else if test -n "$query"
            # 一致するセッションが無いまま Enter した (fzf は 1 で終わる)
            set name $query
        else
            return 1
        end
        SHELL=(status fish-path) zmx attach $name
    end
end
# }}}
