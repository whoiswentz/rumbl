defmodule Rumbl.Multimedia.Video do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {
    :id,
    Rumbl.Multimedia.Permalink,
    autogenerate: true
  }

  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :slug, :string

    belongs_to :user, Rumbl.Accounts.User
    belongs_to :category, Multimedia.Category

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:url, :title, :description, :category_id])
    |> validate_required([:url, :title, :description])
    |> assoc_constraint(:category)
    |> slugfy_title()
  end

  defp slugfy_title(changeset) do
    case fetch_change(changeset, :title) do
      {:ok, new_title} -> put_change(changeset, :title, slugfy(new_title))
      :error -> changeset
    end
  end

  defp slugfy(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end
