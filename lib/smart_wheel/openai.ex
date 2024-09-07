defmodule SmartWheel.Openai do
  def populate_items(prompt) do
    request =
      %{
        model: System.get_env("OPENAI_MODEL"),
        messages: [
          %{
            role: "system",
            response_format: "json_object",
            content: """
            You are an AI tasked with generating items for a roulette or "spin the wheel" game. Your output should be a list of items that can be used in such a game.

            **Task**: Generate a list of 3 to 5 unique items.

            **Output Format**: Provide the items in a array.

            **Guidelines**:
            - Items should be varied and interesting.
            - Each item shoud be limited at least 2 words.
            - Ensure each item is unique.
            """
          },
          %{role: "user", content: prompt}
        ]
      }

    case chat_completion(request) do
      {:ok, response} ->
        {:ok, content} = parse_chat(response.body)

        content =
          if String.starts_with?(content, "```json") do
            content |> String.replace(~r/\A```json/, "") |> String.replace(~r/```$/, "")
          else
            content
          end

        items = Jason.decode!(content)
        {:ok, items}

      {:error, e} ->
        {:error, inspect(e)}
    end
  end

  def chat_completion(request) do
    Req.post(System.get_env("OPENAI_ENDPOINT"),
      json: set_stream(request, false),
      auth: {:bearer, api_key()},
      # receive_timeout: 600_000,
      connect_options: [protocols: [:http1]]
    )
  end

  defp set_stream(request, value) do
    request
    |> Map.drop([:stream, "stream"])
    |> Map.put(:stream, value)
  end

  defp api_key() do
    # Application.get_env(:smart_wheel, :openai)[:api_key]
    System.get_env("OPENAI_API_KEY")
  end

  def parse_chat(%{"choices" => [%{"message" => %{"content" => content}} | _]}) do
    {:ok, content}
  end

  def parse_chat(error) do
    # TODO: Send a notification
    error
  end
end
