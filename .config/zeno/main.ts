import { defineConfig } from "jsr:@yuki-yano/zeno";

export default defineConfig(({ projectRoot, currentDirectory }) => ({
  snippets: [],
  completions: [
    {
      name: "Kill",
      patterns: ["^kill"],
      sourceCommand: "LANG=C ps -ef | sed 1d",
      options: { "--multi": true, "--prompt": "'Kill Process> '" },
      callback: "awk '{print $2}'",
    },
    {
      name: "tfstate for apply",
      patterns: ["^terraform apply -target $"],
      sourceCommand: "terraform state list"
    },
  ],
}));
