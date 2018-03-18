%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ~w{config lib src test web apps},
        excluded: [
          ~r"/_build/",
          ~r"/deps/",
          ~r"/node_modules/",
          # temporarily exclude phoenix generated stuff
          ~r"/config/",
          ~r"/test_helper.exs",
          ~r"/channel_case.ex",
          ~r"/conn_case.ex",
          ~r"/data_case.ex",
          ~r"/application.ex",
          ~r"/repo.ex",
          ~r"/user_socket.ex",
          ~r"/endpoint.ex",
          ~r"/error_helpers.ex",
          ~r"/error_view.ex",
          ~r"/page_controller.ex"
        ]
      },
      strict: true,
      color: true,
      checks: [
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 98},
        {Credo.Check.Readability.Specs, priority: :low}
      ]
    }
  ]
}
