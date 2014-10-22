module ActionView 
  module Helpers

    def tree_list(link_title = '', opts = {}, ztree_opts = {})
      id, cls_name = opts[:id] || 'tree-list', opts[:class] || 'menus_ztree ztree small' 
      ul = content_tag :ul, '', {id: id, class: cls_name, style: "width:260px; overflow:auto;"}.merge(opts)
      return init_tree_js(link_title) +  content_tag(:div, ul, class: 'ground fl') if defined? init_tree_js
      init_tree(link_title, opts, ztree_opts) +  content_tag(:div, ul, class: 'ground fl')
    end
    
    def init_tree(link_title = "", opts = {}, ztree_opts = {})
      js = "$(document).ready(function(){
              if (typeof(treeOpts) == 'undefined'){
                treeOpts = #{{
                             zNodes: ztree_opts[:zNodes] || [],
                             current_tree: "#{opts[:id] || "tree-list"}", 
                             url: "#{ztree_opts[:url] || "/"}"
                           }.to_json}
              }
              if (typeof(ztreeSetting) == 'undefined'){
                ztreeSetting = #{ztree_settings(ztree_opts[:settings] || {})}
              }
              $.fn.zTree.init($('#' + treeOpts.current_tree), ztreeSetting, treeOpts.zNodes);
          "
      js << '});'
      javascript_tag(js) 
    end

    def ztree_settings(opts = {})
      default_settings = {
        view: {
          addHoverDom: "addHoverDom",
          removeHoverDom: "removeHoverDom",
          selectedMulti: false,
        },
        check: {
          #enable: true
        },
        edit: {
          enable: true,
          editNameSelectAll: true,
          showRemoveBtn: true,
          showRenameBtn: true,
          drag: {
            isCopy: true,
            isMove: true,
            prev: true,
            inner: false,
            next: true,
          }
        },
        data: {
          simpleData: {
            enable: true
          }
        },
        callback: {
          beforeDrag: "beforeDrag",
          beforeDrop: "beforeDrop",
          beforeEditName: "beforeEditName",
          beforeRemove: "beforeRemove",
          onDrop: "onDrop",
          onRemove: "onRemove",
          beforeRename: "beforeRename",
          onRename: "onRename",
          onClick: "onClick",
        }
      }
      h_to_j default_settings.merge(opts)
    end
    
    def h_to_j(h)
      h.to_json.html_safe.delete("\"").gsub("=>",": ")
    end
  end
end
