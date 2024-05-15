defmodule Et.MasteryTest do
  use Et.DataCase

  alias Et.Mastery

  describe "verdicts" do
    alias Et.Mastery.Verdict

    import Et.MasteryFixtures

    @invalid_attrs %{topic_id: nil}

    test "list_verdicts/0 returns all verdicts" do
      verdict = verdict_fixture()
      assert Mastery.list_verdicts() == [verdict]
    end

    test "get_verdict!/1 returns the verdict with given id" do
      verdict = verdict_fixture()
      assert Mastery.get_verdict!(verdict.id) == verdict
    end

    test "create_verdict/1 with valid data creates a verdict" do
      valid_attrs = %{topic_id: 42}

      assert {:ok, %Verdict{} = verdict} = Mastery.create_verdict(valid_attrs)
      assert verdict.topic_id == 42
    end

    test "create_verdict/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mastery.create_verdict(@invalid_attrs)
    end

    test "update_verdict/2 with valid data updates the verdict" do
      verdict = verdict_fixture()
      update_attrs = %{topic_id: 43}

      assert {:ok, %Verdict{} = verdict} = Mastery.update_verdict(verdict, update_attrs)
      assert verdict.topic_id == 43
    end

    test "update_verdict/2 with invalid data returns error changeset" do
      verdict = verdict_fixture()
      assert {:error, %Ecto.Changeset{}} = Mastery.update_verdict(verdict, @invalid_attrs)
      assert verdict == Mastery.get_verdict!(verdict.id)
    end

    test "delete_verdict/1 deletes the verdict" do
      verdict = verdict_fixture()
      assert {:ok, %Verdict{}} = Mastery.delete_verdict(verdict)
      assert_raise Ecto.NoResultsError, fn -> Mastery.get_verdict!(verdict.id) end
    end

    test "change_verdict/1 returns a verdict changeset" do
      verdict = verdict_fixture()
      assert %Ecto.Changeset{} = Mastery.change_verdict(verdict)
    end
  end
end
