{ config, pkgs, ... }:
let
  # Configurable variables
  ollamaHost = "localhost";
  ollamaPort = "11434";
  defaultModel = "mistral:7b-instruct-q4_K_M";
  
  commandName = "ask-ai";

  ollama-query = pkgs.writeShellScriptBin commandName ''
    #!/bin/sh
    if [ -z "$1" ]; then
      echo "Usage: ${commandName} \"Your prompt here\""
      echo "       ${commandName} -m llama3 \"Your prompt\" (for different model)"
      exit 1
    fi

    # Handle model flag (-m)
    MODEL="${defaultModel}"
    while getopts ":m:" opt; do
      case $opt in
        m) MODEL="$OPTARG" ;;
        *) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
      esac
    done
    shift $((OPTIND -1))

    [ -z "$1" ] && echo "Error: Missing prompt" >&2 && exit 1

    # Check server availability
    if ! ${pkgs.curl}/bin/curl -s "http://${ollamaHost}:${ollamaPort}/api/tags" >/dev/null; then
      echo "Error: Ollama server not responding at ${ollamaHost}:${ollamaPort}" >&2
      exit 1
    fi

    # Main query with proper newline handling
    ${pkgs.curl}/bin/curl -s -N \
      -X POST \
      -H "Content-Type: application/json" \
      -d "$(${pkgs.jq}/bin/jq -n \
        --arg prompt "$1" \
        --arg model "$MODEL" \
        '{
          model: $model,
          prompt: $prompt,
          stream: true
        }')" \
      "http://${ollamaHost}:${ollamaPort}/api/generate" | \
      while IFS= read -r line; do
        [ -z "$line" ] && continue
        
        # Process response and preserve newlines
        response="$(${pkgs.jq}/bin/jq -r '
          if .response? and .response != "" then 
            (.response | gsub("\\\\n"; "\n")) 
          else empty 
          end' <<< "$line" 2>/dev/null)"
        
        # Print while preserving formatting
        [ -n "$response" ] && printf "%b" "$response"
        
        # Final newline when done
        echo "$line" | ${pkgs.jq}/bin/jq -e '.done == true' >/dev/null 2>&1 && echo
      done
  '';

in {

  environment.systemPackages = [ ollama-query pkgs.wget pkgs.jq ];



  services.ollama = {
    enable = true;
    acceleration = false;
    openFirewall = true;
    host = "0.0.0.0";
    port = 11434;
  };
}
