// Adapted from https://github.com/dabroz/cocoon-js-vanilla for usage with Stimulus

export default class Cocoon {
  static cocoonElementCounter = 0;

  static createNewID() {
    return (new Date().getTime() + Cocoon.cocoonElementCounter++);
  };

  static newcontentBraced(id) {
    return '[' + id + ']$1';
  };

  static newcontentUnderscored(id) {
    return '_' + id + '_$1';
  };

  static getInsertionNodeElem(insertionNode, insertionTraversal, thisNode) {
    if (!insertionNode) {
      return thisNode.parentNode;
    }

    if (typeof insertionNode === 'function') {
      if (insertionTraversal) {
        console.warn('association-insertion-traversal is ignored, because association-insertion-node is given as a function.');
      }
      return insertionNode(thisNode);
    }

    if (typeof insertionNode === 'string') {
      if (insertionTraversal) {
        return thisNode[insertionTraversal](insertionNode);
      } else {
        return insertionNode === 'this' ? thisNode : document.querySelector(insertionNode);
      }
    }
  };

  static cocoonDetach(node) {
    return node.parentElement.removeChild(node);
  };

  static cocoonGetPreviousSibling(elem, selector) {
    var sibling = elem.previousElementSibling;

    if (!selector) return sibling;

    while (sibling) {
      var match = sibling.matches(selector);
      if (match) return sibling;
      sibling = sibling.previousElementSibling;
    }
  };

  static cocoonAddFields(e, target) {
    e.preventDefault();
    e.stopPropagation();

    let thisNode = target;
    let assoc = thisNode.getAttribute('data-association');
    let assocs = thisNode.getAttribute('data-associations');
    let content = thisNode.getAttribute('data-association-insertion-template');
    let insertionMethod = thisNode.getAttribute('data-association-insertion-method') || thisNode.getAttribute('data-association-insertion-position') || 'before';
    let insertionNode = thisNode.getAttribute('data-association-insertion-node');
    let insertionTraversal = thisNode.getAttribute('data-association-insertion-traversal');
    let count = parseInt(thisNode.getAttribute('data-count'), 10);
    let regexpBraced = new RegExp('\\[new_' + assoc + '\\](.*?\\s)', 'g');
    let regexpUnderscored = new RegExp('_new_' + assoc + '_(\\w*)', 'g');
    let newId = Cocoon.createNewID();
    let newContent = content.replace(regexpBraced, Cocoon.newcontentBraced(newId));
    let newContents = [];
    let originalEvent = e;

    if (newContent === content) {
      regexpBraced = new RegExp('\\[new_' + assocs + '\\](.*?\\s)', 'g');
      regexpUnderscored = new RegExp('_new_' + assocs + '_(\\w*)', 'g');
      newContent = content.replace(regexpBraced, Cocoon.newcontentBraced(newId));
    }

    newContent = newContent.replace(regexpUnderscored, Cocoon.newcontentUnderscored(newId));
    newContents = [newContent];

    count = (isNaN(count) ? 1 : Math.max(count, 1));
    count -= 1;

    while (count) {
      newId = Cocoon.createNewID();
      newContent = content.replace(regexpBraced, Cocoon.newcontentBraced(newId));
      newContent = newContent.replace(regexpUnderscored, Cocoon.newcontentUnderscored(newId));
      newContents.push(newContent);

      count -= 1;
    }

    let insertionNodeElem = Cocoon.getInsertionNodeElem(insertionNode, insertionTraversal, thisNode);

    if (!insertionNodeElem || (insertionNodeElem.length === 0)) {
      console.warn("Couldn't find the element to insert the template. Make sure your `data-association-insertion-*` on `link_to_add_association` is correct.");
    }

    newContents.forEach(function (node, i) {
      let contentNode = node;

      let beforeInsert = new CustomEvent('cocoon:before-insert', { cancelable: true, detail: [contentNode, originalEvent] });
      insertionNodeElem.dispatchEvent(beforeInsert);

      if (!beforeInsert.defaultPrevented) {
        // allow any of the jquery dom manipulation methods (after, before, append, prepend, etc)
        // to be called on the node.  allows the insertion node to be the parent of the inserted
        // code and doesn't force it to be a sibling like after/before does. default: 'before'
        let htmlMapping = {
          before: 'beforebegin',
          prepend: 'afterbegin',
          append: 'beforeend',
          after: 'afterend',
        };
        let htmlMethod = htmlMapping[insertionMethod];
        let addedContent = insertionNodeElem.insertAdjacentHTML(htmlMethod, contentNode);

        let afterInsert = new CustomEvent('cocoon:after-insert', { detail: [contentNode, originalEvent, addedContent] });
        insertionNodeElem.dispatchEvent(afterInsert);
      }
    });
  };

  static cocoonRemoveFields(e, target) {
    let thisNode = target;
    let wrapperClass = thisNode.getAttribute('data-wrapper-class') || 'nested-fields';
    let nodeToDelete = thisNode.closest('.' + wrapperClass);
    let triggerNode = nodeToDelete.parentNode;
    let originalEvent = e;

    e.preventDefault();
    e.stopPropagation();

    let beforeRemove = new CustomEvent('cocoon:before-remove', { cancelable: true, detail: [nodeToDelete, originalEvent] });
    triggerNode.dispatchEvent(beforeRemove);

    if (!beforeRemove.defaultPrevented) {
      let timeout = triggerNode.getAttribute('data-remove-timeout') || 0;

      setTimeout(function () {
        if (thisNode.classList.contains('dynamic')) {
          Cocoon.cocoonDetach(nodeToDelete);
        } else {
          let hiddenInput = Cocoon.cocoonGetPreviousSibling(thisNode, 'input[type=hidden]');
          hiddenInput.value = '1';
          nodeToDelete.style.display = 'none';
        }
        let afterRemove = new CustomEvent('cocoon:after-remove', { detail: [nodeToDelete, originalEvent] });
        triggerNode.dispatchEvent(afterRemove);
      }, timeout);
    }
  };
};
