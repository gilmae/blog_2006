CREATE TABLE `Threading` (
  `ThreadingID` int(11) NOT NULL,
  `ThreadID` int(11) default NULL,
  `BlockID` int(11) default NULL,
  PRIMARY KEY  (`ThreadingID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `authors` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `login` varchar(255) default NULL,
  `hashed_password` varchar(255) default NULL,
  `salt` varchar(255) default NULL,
  `type` varchar(255) default NULL,
  `sponsor_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `blogs` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `sub_title` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `domain` varchar(255) default NULL,
  `theme` varchar(255) default NULL,
  `config_hash` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `blogs_editors` (
  `blog_id` int(11) default NULL,
  `editor_id` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ips` (
  `id` int(11) NOT NULL auto_increment,
  `ip` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `spam_attempts` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `nodes` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `body` text,
  `precis` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `published_at` datetime default NULL,
  `parent_id` int(11) default NULL,
  `permalink` varchar(255) default NULL,
  `author_id` int(11) default NULL,
  `comments_closed` tinyint(1) default NULL,
  `blog_id` int(11) default NULL,
  `ip_id` int(11) default NULL,
  `content_status` enum('spam','ham') default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

CREATE TABLE `nodes_tags` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) default NULL,
  `node_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `oldnodes` (
  `nodeID` int(11) NOT NULL,
  `nodeTitle` varchar(100) default NULL,
  `nodeBody` text,
  `nodePrecise` text,
  `datetime` varchar(14) default NULL,
  `nodeType` char(1) default NULL,
  `parentNode` int(11) default NULL,
  `nextSibling` int(11) default '-1',
  `prevSibling` int(11) default '-1',
  `childNodes` int(11) default NULL,
  `threadID` int(11) default '-1',
  `FirstChild` int(11) default '-1',
  `LastChild` int(11) default '-1',
  `postedBy` int(11) default NULL,
  `public` int(11) default '1',
  `Edited` char(1) default '',
  `Pings` int(11) default '0',
  PRIMARY KEY  (`nodeID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `taggings` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) default NULL,
  `taggable_id` int(11) default NULL,
  `taggable_type` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `tagging_taggable_type_index` (`taggable_type`)
) ENGINE=InnoDB AUTO_INCREMENT=639 DEFAULT CHARSET=latin1;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `thread_branches` (
  `id` int(11) NOT NULL auto_increment,
  `thread_id` int(11) default NULL,
  `branch_node_id` int(11) default NULL,
  `branch_node_type` varchar(255) default NULL,
  `thread_type` varchar(255) default NULL,
  `levels_from_root` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `tokens` (
  `id` int(11) NOT NULL auto_increment,
  `nonce` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `token` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=370 DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `counter` int(11) NOT NULL,
  `userID` varchar(20) default NULL,
  `password` varchar(20) default NULL,
  `userName` varchar(30) default NULL,
  `email` varchar(100) default NULL,
  `url` varchar(100) default NULL,
  `admin` tinyint(4) default NULL,
  `trusted` tinyint(4) default '0',
  PRIMARY KEY  (`counter`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO `schema_info` (version) VALUES (9)