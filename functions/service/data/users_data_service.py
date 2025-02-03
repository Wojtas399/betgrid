from functions.collections_references import CollectionsReferences


class UsersDataService:
    def __init__(self):
        self.collections_references = CollectionsReferences()

    def load_ids_of_all_users(self):
        docs = self.collections_references.users.stream()
        return [doc.id for doc in docs]
