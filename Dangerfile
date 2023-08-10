warn "This PR's base branch is `#{github.branch_for_base}` rather than `develop`" if github.branch_for_base != "develop"
if git.commits.any? { |c| c.message =~ /^Merge branch/ }
  warn 'Please rebase to get rid of the merge commits in this PR'
end
File.readlines(ENV['PROJECT_PATH']).each_with_index do |line, index|
	if line.include?("sourceTree = SOURCE_ROOT;") and line.include?("PBXFileReference")
		warn("Files should be in sync with project structure", file: project_file, line: index + 1) 
	end
end if ENV['PROJECT_PATH'] && File.file?(ENV['PROJECT_PATH'])