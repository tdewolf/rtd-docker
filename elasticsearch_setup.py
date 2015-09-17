from readthedocs.search.indexes import Index, PageIndex, ProjectIndex, SectionIndex

# Create the index.
index = Index()
index_name = index.timestamped_index()
index.create_index(index_name)
index.update_aliases(index_name)
# Update mapping
proj = ProjectIndex()
proj.put_mapping()
page = PageIndex()
page.put_mapping()
sec = SectionIndex()
sec.put_mapping()
