#!/usr/bin/env python3
"""計画ファイルの処理と index.md 生成（Agents → YYYY → MM → DD → leaf を toctree で連結）"""

import json
import sys
import re
from datetime import datetime
from pathlib import Path

BASE_DIR = Path.home() / "Documents" / "notizen" / "source" / "Agents"


def write_index_md(
    target_dir: Path, title: str, glob_pattern: str, maxdepth: int = 1
) -> None:
    """target_dir/index.md を作成（MyST toctree + glob）"""
    target_dir.mkdir(parents=True, exist_ok=True)
    index_path = target_dir / "index.md"

    content = f"""# {title}

```{{toctree}}
:maxdepth: {maxdepth}
:glob:

{glob_pattern}
```
"""
    index_path.write_text(content, encoding="utf-8")


def update_agents_root_index() -> None:
    """Agents/index.md を更新（年ディレクトリをぶら下げる）"""
    write_index_md(BASE_DIR, "Agents", "*/index", maxdepth=1)


def update_indexes_for_date(date: datetime) -> None:
    """指定日付の年/月/日ディレクトリ + Agents 直下に index.md を作成/更新"""
    year_dir = BASE_DIR / date.strftime("%Y")
    month_dir = year_dir / date.strftime("%m")
    day_dir = month_dir / date.strftime("%d")

    # 日（leaf）: YYYY/MM/DD 形式
    write_index_md(day_dir, date.strftime("%Y/%m/%d"), "*", maxdepth=1)

    # 月: YYYY/MM 形式
    write_index_md(month_dir, date.strftime("%Y/%m"), "*/index", maxdepth=1)

    # 年: YYYY 形式
    write_index_md(year_dir, date.strftime("%Y"), "*/index", maxdepth=1)

    # Agents ルート: 年ディレクトリ配下の index を列挙
    update_agents_root_index()


def generate_all_indexes() -> None:
    """全ての年/月/日ディレクトリに index.md を生成し、最後に Agents/index.md も生成"""
    if not BASE_DIR.exists():
        print(f"Directory not found: {BASE_DIR}")
        return

    # 年/月/日を走査して作る
    for year_dir in sorted(BASE_DIR.iterdir()):
        if not year_dir.is_dir() or not year_dir.name.isdigit():
            continue

        for month_dir in sorted(year_dir.iterdir()):
            if not month_dir.is_dir() or not month_dir.name.isdigit():
                continue

            for day_dir in sorted(month_dir.iterdir()):
                if not day_dir.is_dir() or not day_dir.name.isdigit():
                    continue

                # 日（leaf）: YYYY/MM/DD 形式
                date_path = f"{year_dir.name}/{month_dir.name}/{day_dir.name}"
                write_index_md(day_dir, date_path, "*", maxdepth=1)
                print(f"Created: {day_dir / 'index.md'}")

            # 月: YYYY/MM 形式
            date_path = f"{year_dir.name}/{month_dir.name}"
            write_index_md(month_dir, date_path, "*/index", maxdepth=1)
            print(f"Created: {month_dir / 'index.md'}")

        # 年: YYYY 形式
        write_index_md(year_dir, year_dir.name, "*/index", maxdepth=1)
        print(f"Created: {year_dir / 'index.md'}")

    # Agents ルート（年一覧）
    update_agents_root_index()
    print(f"Created: {BASE_DIR / 'index.md'}")


def process_plan_file(file_path: str) -> Path | None:
    """計画ファイルに時刻を追加し、日付階層で notizen に移動"""
    path = Path(file_path)
    if not path.exists() or path.suffix != ".md":
        return None

    # 計画ファイルかどうか確認
    if ".claude/plans/" not in str(path):
        return None

    content = path.read_text(encoding="utf-8")

    # 既に先頭に時刻が含まれている場合はスキップ
    if re.search(r"^#\s+\d{2}:\d{2}:\d{2}\s", content, re.MULTILINE):
        return None

    now = datetime.now()
    time_str = now.strftime("%H:%M:%S")

    # H1 見出しの先頭に時刻を追加
    new_content = re.sub(
        r"^(#\s+)(.+)$",
        rf"\g<1>{time_str} \g<2>",
        content,
        count=1,
        flags=re.MULTILINE,
    )

    # 日付階層のディレクトリ作成
    dest_dir = BASE_DIR / now.strftime("%Y/%m/%d")
    dest_dir.mkdir(parents=True, exist_ok=True)

    # ファイル名にタイムスタンプを追加
    new_name = f"{now.strftime('%H%M%S')}_{path.name}"
    dest_path = dest_dir / new_name
    dest_path.write_text(new_content, encoding="utf-8")

    # 元ファイルを削除
    path.unlink()

    # index.md を更新（Agents → YYYY → MM → DD を必ず連結）
    update_indexes_for_date(now)

    return dest_path


if __name__ == "__main__":
    # 引数なし or --generate-all: 全ディレクトリの index.md を生成
    if len(sys.argv) > 1 and sys.argv[1] == "--generate-all":
        generate_all_indexes()
    elif sys.stdin.isatty():
        # 標準入力がない場合も全生成
        generate_all_indexes()
    else:
        # Claude Code フックとして実行
        input_data = json.load(sys.stdin)
        file_path = input_data.get("tool_input", {}).get("file_path", "")
        dest = process_plan_file(file_path) if file_path else None
        if dest:
            print(f"Moved to: {dest}", file=sys.stderr)
