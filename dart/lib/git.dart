import 'dart:io';

void removeLocalBranches() async{
  var gitPath = "C:\\Users\\guilherme\\Desktop\\git\\w12\\Evo3";
  var forceDelete = true;
  List<String> localBranches = await _getLocalBranches(gitPath);
  List<String>  remoteBranches = await _getRemoteBranches(gitPath);

  await _statusBranch(gitPath);
  await _pruneBranch(gitPath);
  await _checkoutBranch(gitPath, 'master');
  await _pullBranch(gitPath);

  for (var branch in localBranches) {
    if(branch.trim().replaceAll('* ', '') == 'master') continue;
    if(!remoteBranches.any((e) => e.replaceAll('origin/', '').trim() == branch.replaceAll('* ', '').trim())){
      print(branch);
      await _deleteBranch(gitPath, branch.replaceAll('* ', '').trim(), force: forceDelete);
    }
  }
}

_getRemoteBranches(String gitPath) async{
  var remoteBranches = [];
  await Process.run("git --git-dir $gitPath\\.git --work-tree $gitPath branch -r", [], runInShell: true).then((result) {
    remoteBranches = result.stdout.toString().split('\n');
  });
  return remoteBranches;
}

_getLocalBranches(String gitPath) async{
  var localBranches = [];
  await Process.run("git --git-dir $gitPath\\.git --work-tree $gitPath branch", [], runInShell: true).then((result) {
    localBranches = result.stdout.toString().split('\n');
  });
  return localBranches;
}

_checkoutBranch(String gitPath, String branch) async {
  await Process.run("git --git-dir $gitPath\\.git --work-tree $gitPath checkout $branch", [], runInShell: true).then((result) {
    print(result.stderr);
  });
}

_pruneBranch(String gitPath) async{
  await Process.run("git --git-dir $gitPath\\.git --work-tree $gitPath remote update --prune", [], runInShell: true).then((result) {
    print(result.stderr);
  });
}

_deleteBranch(String gitPath, String branch, {bool force = false}) async{
  await Process.run("git --git-dir $gitPath\\.git --work-tree $gitPath branch ${force ? '-D' : '-d'} $branch", [], runInShell: true).then((result) {
    print(result.stderr);
  });
}

_pullBranch(String gitPath) async{
  await Process.run("git --git-dir $gitPath\\.git --work-tree $gitPath pull", [], runInShell: true).then((result) {
    print(result.stdout);
  });
}

_statusBranch(String gitPath) async{
  await Process.run("git --git-dir $gitPath\\.git --work-tree $gitPath status", [], runInShell: true).then((result) {
    print(result.stdout);
  });
}