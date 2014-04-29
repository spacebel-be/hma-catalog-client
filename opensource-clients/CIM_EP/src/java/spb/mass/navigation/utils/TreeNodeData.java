package spb.mass.navigation.utils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.primefaces.model.DefaultTreeNode;
import org.primefaces.model.TreeNode;

/**
 * Model for the Collection Picker. Also parses our syntax for collections in
 * the wizard.
 * 
 * @author jpr
 * 
 */
public class TreeNodeData {
	private String label;
	private String value;
	private boolean leaf;

	private static Logger log = Logger.getLogger(TreeNodeData.class);

	private static String separator = "[]";

	public TreeNodeData(String label, String value) {
		super();
		this.label = label;
		this.value = value;
		this.leaf = true;
	}

	public static TreeNode buildTree(String collections) {
		DefaultTreeNode root = new DefaultTreeNode(new TreeNodeData(
				"Root", "Node"), null);
		List<String> lines = new ArrayList<String>(Arrays.asList(collections
				.split("\n")));
		// removing empty lines
		Iterator<String> it = lines.iterator();
		while (it.hasNext()) {
			String line = it.next();
			if (StringUtils.isBlank(line)) {
				it.remove();
			}
		}
		processNextLine(lines, 0, root, 0);
		return root;
	}

	private static void processNextLine(List<String> lines, int lineIndex,
			DefaultTreeNode lastNode, int lastNodeLevel) {
		if (lineIndex < lines.size()) {
			String currentLine = lines.get(lineIndex);
			int currentLevel = StringUtils.countMatches(currentLine, separator);
			if (currentLevel > 0) {
				TreeNodeData data = new TreeNodeData(findLabel(currentLine),
						findValue(currentLine));
				if (currentLevel > lastNodeLevel) {
					TreeNodeData parentData = (TreeNodeData) lastNode.getData();
					parentData.setLeaf(false);
					DefaultTreeNode node = new DefaultTreeNode(data, lastNode);
					processNextLine(lines, lineIndex + 1, node, currentLevel);
				} else if (currentLevel == lastNodeLevel) {
					DefaultTreeNode node = new DefaultTreeNode(data,
							lastNode.getParent());
					processNextLine(lines, lineIndex + 1, node, currentLevel);
				} else {
					DefaultTreeNode newParent = lastNode;
					for (int i = 0; i <= lastNodeLevel - currentLevel; i++) {
						newParent = (DefaultTreeNode) newParent.getParent();
					}
					DefaultTreeNode node = new DefaultTreeNode(data, newParent);
					processNextLine(lines, lineIndex + 1, node, currentLevel);
				}
			}
		}
	}

	private static String findLabel(String completeLine) {
		int startPos = completeLine.lastIndexOf(separator);
		if (startPos == -1) {
			startPos = 0;
		} else {
			startPos += separator.length();
		}
		int endPos = completeLine.lastIndexOf("{");
		if (endPos == -1) {
			endPos = completeLine.length();
		}
		return completeLine.substring(startPos, endPos).trim();

	}

	private static String findValue(String completeLine) {
		int startPos = completeLine.lastIndexOf("{");
		int endPos = completeLine.lastIndexOf("}");
		if (startPos != -1 && endPos != -1 && endPos > startPos) {
			return completeLine.substring(startPos + 1, endPos).trim();
		} else {
			return null;
		}
	}

	@Override
	public String toString() {
		return "TreeNodeData [label=" + label + ", value=" + value + "]";
	}

	public static String[] buildString(TreeNode[] nodes) {
		List<String> collections = new ArrayList<String>();
		for (TreeNode node : nodes) {
			TreeNodeData data = (TreeNodeData) node.getData();
			if (data.getValue() != null) {
				collections.add(data.getValue());
			}
		}
		return collections.toArray(new String[0]);
	}

	public static TreeNode[] buildTreeNodes(String collections) {
		List<TreeNode> nodes = new ArrayList<TreeNode>();
		if (StringUtils.isNotBlank(collections)) {
			String[] colls = collections.split(",");
			for (String collection : colls) {
				TreeNodeData data = new TreeNodeData(collection, collection);
				TreeNode node = new DefaultTreeNode(data, null);
				nodes.add(node);
			}
		}
		return nodes.toArray(new DefaultTreeNode[0]);
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public boolean isLeaf() {
		return leaf;
	}

	public void setLeaf(boolean leaf) {
		this.leaf = leaf;
	}

}
