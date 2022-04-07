# Data Manipulation

tree <- readRDS('tree_data.RData')


tree$part_problem <- ifelse(
  ((tree$root_stone == 'Yes' | tree$root_grate == 'Yes' | tree$root_other == 'Yes') & !(tree$trunk_wire == 'Yes' | tree$trnk_light == 'Yes' | tree$trnk_other == 'Yes') & !(tree$brch_other == 'Yes' | tree$brch_shoe == 'Yes' | tree$brch_light == 'Yes')) , 'Root',
  ifelse((!(tree$root_stone == 'Yes' | tree$root_grate == 'Yes' | tree$root_other == 'Yes') & (tree$trunk_wire == 'Yes' | tree$trnk_light == 'Yes' | tree$trnk_other == 'Yes') & !(tree$brch_other == 'Yes' | tree$brch_shoe == 'Yes' | tree$brch_light == 'Yes')) , 'Trunk',
         ifelse((!(tree$root_stone == 'Yes' | tree$root_grate == 'Yes' | tree$root_other == 'Yes') & !(tree$trunk_wire == 'Yes' | tree$trnk_light == 'Yes' | tree$trnk_other == 'Yes') & (tree$brch_other == 'Yes' | tree$brch_shoe == 'Yes' | tree$brch_light == 'Yes')) , 'Branch',
                ifelse(((tree$root_stone == 'Yes' | tree$root_grate == 'Yes' | tree$root_other == 'Yes') & (tree$trunk_wire == 'Yes' | tree$trnk_light == 'Yes' | tree$trnk_other == 'Yes') & !(tree$brch_other == 'Yes' | tree$brch_shoe == 'Yes' | tree$brch_light == 'Yes')) , 'Multiple',
                       ifelse((!(tree$root_stone == 'Yes' | tree$root_grate == 'Yes' | tree$root_other == 'Yes') & (tree$trunk_wire == 'Yes' | tree$trnk_light == 'Yes' | tree$trnk_other == 'Yes') & (tree$brch_other == 'Yes' | tree$brch_shoe == 'Yes' | tree$brch_light == 'Yes')) , 'Multiple',
                              ifelse(((tree$root_stone == 'Yes' | tree$root_grate == 'Yes' | tree$root_other == 'Yes') & !(tree$trunk_wire == 'Yes' | tree$trnk_light == 'Yes' | tree$trnk_other == 'Yes') & (tree$brch_other == 'Yes' | tree$brch_shoe == 'Yes' | tree$brch_light == 'Yes')) , 'Multiple',
                                     ifelse(((tree$root_stone == 'Yes' | tree$root_grate == 'Yes' | tree$root_other == 'Yes') & (tree$trunk_wire == 'Yes' | tree$trnk_light == 'Yes' | tree$trnk_other == 'Yes') & (tree$brch_other == 'Yes' | tree$brch_shoe == 'Yes' | tree$brch_light == 'Yes')) , 'Multiple',
                                            'None')))))))


tree$guards <- ifelse(tree$guards == "", "None", tree$guards)
tree$sidewalk <- ifelse(tree$sidewalk == "", "Unsure", tree$sidewalk)
tree$health <- ifelse(tree$health == "", "Unsure", tree$health)
