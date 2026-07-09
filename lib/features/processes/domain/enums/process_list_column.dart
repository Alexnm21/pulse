enum ProcessListColumn {
  name(4),
  cpu(2),
  memory(2),
  user(2);

  const ProcessListColumn(this.flex);
  final int flex;
}
