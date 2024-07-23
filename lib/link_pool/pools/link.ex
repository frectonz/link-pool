defmodule LinkPool.Pools.Link do
  use Ecto.Schema
  import Ecto.Changeset
  alias LinkPool.Pools.Pool

  schema "pool_links" do
    field :title, :string
    field :url, :string
    field :icon, :string
    belongs_to :pool, Pool

    field(:delete, :boolean, virtual: true)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    changeset =
      link
      |> cast(attrs, [:title, :url, :icon])
      |> validate_required([:url])
      |> maybe_fetch_metadata()
      |> validate_required([:title, :icon])

    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end

  defp maybe_fetch_metadata(changeset) do
    if url = get_change(changeset, :url) do
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{body: body, request_url: base_url}} ->
          title = extract_title(body)
          icon = extract_icon(body, base_url)

          changeset
          |> put_change(:title, title)
          |> put_change(:icon, icon)

        {:error, _} ->
          changeset
          |> add_error(:url, "Failed to fetch metadata")
      end
    else
      changeset
    end
  end

  defp extract_title(body) do
    body
    |> Floki.parse_document!()
    |> Floki.find("title")
    |> Floki.text()
  end

  defp extract_icon(body, base_url) do
    icon_url =
      body
      |> Floki.parse_document!()
      |> Floki.find("link[rel='icon']")
      |> Floki.attribute("href")
      |> List.first()

    if icon_url && String.starts_with?(icon_url, "/") do
      URI.merge(base_url, icon_url) |> to_string()
    else
      icon_url
    end
  end
end
