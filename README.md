# Semantic_Coder
 A simple semantic coder based on WordNet

# Source 

You find WordNet here: https://wordnet.princeton.edu/download/current-version

Access Date: 17.06.2022

Cite WordNet as: Princeton University "About WordNet." WordNet. Princeton University. 2010. 

I downloaded the WordNet 3.1 Database files 

# Aim of my script 

My aim was to create a single file which contains all verbal lemmas listed in the WordNet database and the most frequent sense of each verb (i.e. body, change, cognition, communication, competition, consumption, contact, creation, emotion, motion, perception, possession, social, stative or weather), which can then be used to code corpus-based data for verb sense. A verbal lemma will then be assigned the most frequent sense of that lemma, irrespective of the context, i.e. homography and polysemy will be disregarded and, for instance, all tokens of "give" tagged as "possession". This creates somewhat noisy data, but allows for the coding of large amounts of data.

The steps below document how such a file (index_verb_coded.txt) was generated. If you want to use index_verb_coded.txt, you do not need to follow these steps. Simply run "WordNet application.R".



# How the relevant information on WordNet was consolidated in a single file

## Step 1
The file data.verb contains a separate entry for each sense as well as a number pointing to the corresponding synset-file, i.e. to the semantic category. It is unclear which of the given senses in this file is the most frequent one. As a measure of caution, I am therefore only using it to create a link between the sense-number and the synset-file


### Modifications of data.verb:
1. Rename as .txt.
2. Manually delete the header.
3. Delete anything but the two required numbers (using an editor).

Search:`^(\d{8} \d{2}).+`

Replace:`\1`

4. Replace numbers with the corresponding sense, based on the list below, e.g.:

Search:` 29\n`

Replace:`\tbody\n`


> 29	verb.body	verbs of grooming, dressing and bodily care

> 30	verb.change	verbs of size, temperature change, intensifying, etc.

> 31	verb.cognition	verbs of thinking, judging, analyzing, doubting

> 32	verb.communication	verbs of telling, asking, ordering, singing

> 33	verb.competition	verbs of fighting, athletic activities

> 34	verb.consumption	verbs of eating and drinking

> 35	verb.contact	verbs of touching, hitting, tying, digging

> 36	verb.creation	verbs of sewing, baking, painting, performing

> 37	verb.emotion	verbs of feeling

> 38	verb.motion	verbs of walking, flying, swimming

> 39	verb.perception	verbs of seeing, hearing, feeling

> 40	verb.possession	verbs of buying, selling, owning

> 41	verb.social	verbs of political and social activities and events

> 42	verb.stative	verbs of being, having, spatial relations

> 43	verb.weather	verbs of raining, snowing, thawing, thundering

Source: https://wordnet.princeton.edu/documentation/lexnames5wn


## Step 2
The file index.verb contains all lemmas (i.e. infinitives, but only one entry per form, even in the case of homography/polysemy) and all senses associated with a lemma in order of decreasing frequency. The aim of this step is to link each lemma with its most frequent sense.

### Modification of index.verb:
1. Rename as .txt.
2. Manually delete the header.
3. Delete anything but the sense number and the lemma.

Search:`( ..?){1,} `

Replace:`\t`

4. Delete als sense numbers but the first one.

Search:` (\t\d+) .+`

Replace:`\1`

5. Manually delete the last (empty) row.
6. Replace all underscores with hyphens (made it more likely to find forms in my corpus output).

**Relevant info:**
Senses in WordNet are generally ordered from most to least frequently used, with the most common sense numbered 1 . Frequency of use is determined by the number of times a sense is tagged in the various semantic concordance texts. Senses that are not semantically tagged follow the ordered senses. The tagsense_cnt field for each entry in the index.pos files indicates how many of the senses in the list have been tagged.

Source: https://wordnet.princeton.edu/documentation/wndb5wn


## Step 3

Combine modified data.verb with index.verb using the R script "WordNet preparation.R".







# More information about the structure of WordNet files

Any text marked as a quote has been directly copied from the wordnet.princeton.edu website (source given below each paragraph).



## Lexicographer files
e.g. the file verb.contact

> Lexicographer files correspond to the syntactic categories implemented in WordNet - noun, verb, adjective and adverb. All of the synsets in a lexicographer file are in the same syntactic category. Each synset consists of a list of synonymous words or collocations (eg. "fountain pen" , "take in" ), and pointers that describe the relations between this synset and other synsets. These relations include (but are not limited to) hypernymy/hyponymy, antonymy, entailment, and meronymy/holonymy. A word or collocation may appear in more than one synset, and in more than one part of speech. Each use of a word in a synset represents a sense of that word in the part of speech corresponding to the synset.

Source: https://wordnet.princeton.edu/documentation/wninput5wn

### one synset = one line

> For verbs, the basic synset syntax is defined as follows:
> `{   words  pointers  frames   (  gloss  )  }` 

>Word/pointer syntax is of the form:
>`[   word[ ( marker ) ][lex_id] ,   pointers   ] `

>For verbs, the word/pointer syntax is extended in the following manner to allow the user to specify generic sentence frames that, like pointers, correspond only to a specific word, rather than all the words in the synset. In this case, pointers are optional.
>`[   word ,   [pointers]  frames   ] `

>Pointers are optional in synsets. If a pointer is specified outside of a word/pointer set, the relation is applied to all of the words in the synset, including any words specified using the word/pointer syntax. This indicates a semantic relation between the meanings of the words in the synsets. If specified within a word/pointer set, the relation corresponds only to the word in the set and represents a lexical relation.
A pointer is of the form:
`[lex_filename : ]word[lex_id] , pointer_symbol `
or:
`[lex_filename : ]word[lex_id] ^ word[lex_id] , pointer_symbol `

Source: https://wordnet.princeton.edu/documentation/wninput5wn


### concerning polysemy/homography
> word [here: a placeholder] may be followed by an integer lex\_id from 1 to 15 . The lex\_id is used to distinguish different senses of the same word within a lexicographer file. The lexicographer assigns lex\_id values, usually in ascending order, although there is no requirement that the numbers be consecutive. The default is 0 , and does not have to be specified. 

Source: https://wordnet.princeton.edu/documentation/wninput5wn

The most important point here is "usually in ascending order", because it indicates that senses appear in order of decreasing frequency.

**Summary: The structure of the lexicographer files would be difficult to work with for our purposes due to the many semantic relations which can hold between the words in a synset.**


## Index.verb

>For each syntactic category, two files are needed to represent the contents of the WordNet database - index. pos and data. pos , where pos is noun , verb , adj and adv .

>Each index file is an alphabetized list of all the words found in WordNet in the corresponding part of speech. On each line, following the word, is a list of byte offsets (synset\_offset s) in the corresponding data file, one for each synset containing the word. Words in the index file are in lower case only, regardless of how they were entered in the lexicographer files. This folds various orthographic representations of the word into one line enabling database searches to be case insensitive. 

Source: https://wordnet.princeton.edu/documentation/wndb5wn


### Header

>Each index file begins with several lines containing a copyright notice, version number, and license agreement. These lines all begin with two spaces and the line number so they do not interfere with the binary search algorithm that is used to look up entries in the index files.

Source: https://wordnet.princeton.edu/documentation/wndb5wn

### Other lines
> All other lines are in the following format. In the field descriptions, number always refers to a decimal integer unless otherwise defined. 
>`lemma pos  synset_cnt  p_cnt  [ptr_symbol...]  sense_cnt  tagsense_cnt   synset_offset  [synset_offset...] `

### lemma

> lower case ASCII text of word or collocation. Collocations are formed by joining individual words with an underscore (\_) character.

### pos
> Syntactic category: n for noun files, v for verb files, a for adjective files, r for adverb files.
>All remaining fields are with respect to senses of lemma in pos .

### synset\_cnt
> Number of synsets that lemma is in. This is the number of senses of the word in WordNet. See Sense Numbers below for a discussion of how sense numbers are assigned and the order of synset_offset s in the index files.

### p\_cnt
>Number of different pointers that lemma has in all synsets containing it.

### ptr_symbol
>A space separated list of p\_cnt different types of pointers that lemma has in all synsets containing it. See wninput(5WN) for a list of pointer\_symbol s. If all senses of lemma have no pointers, this field is omitted and p\_cnt is 0 .

>The pointer_symbol s for verbs are:

>`!`    Antonym 

>`@`    Hypernym 

>`~`    Hyponym 

>`*`    Entailment 

>`>`    Cause 

>`^`    Also see 

>`$`    Verb Group 

>`+`    Derivationally related form         

>`;c`    Domain of synset - TOPIC 

>`;r`    Domain of synset - REGION 

>`;u`    Domain of synset - USAGE 

Source: https://wordnet.princeton.edu/documentation/wninput5wn

### sense\_cnt

>Same as sense\_cnt above. This is redundant, but the field was preserved for compatibility reasons.

### tagsense\_cnt

> Number of senses of lemma that are ranked according to their frequency of occurrence in semantic concordance texts.

### synset\_offset

>Byte offset in data.pos file of a synset containing lemma . Each synset\_offset in the list corresponds to a different sense of lemma in WordNet. synset\_offset is an 8 digit, zero-filled decimal integer that can be used with fseek(link is external)(3)(link is external) to read a synset from the data file. When passed to read_synset(3WN) along with the syntactic category, a data structure containing the parsed synset is returned.

Source: https://wordnet.princeton.edu/documentation/wndb5wn


**! The Index file contains entries such as this one:**

> aggregate v 2 3 @ ~ + 2 0 02633636 01387824  

**It contains pointers to two senses, but it is unclear whether they are ranked in order of decreasing frequency.**



## Data.verb

> Each data file begins with several lines containing a copyright notice, version number, and license agreement. These lines all begin with two spaces and the line number. All other lines are in the following format. Integer fields are of fixed length and are zero-filled.

`synset_offset  lex_filenum  ss_type  w_cnt  word  lex_id  [word  lex_id...]  p_cnt  [ptr...]  [frames...]  |   gloss `

### synset\_offset

> Current byte offset in the file represented as an 8 digit decimal integer.

### lex\_filenum

> Two digit decimal integer corresponding to the lexicographer file name containing the synset. See lexnames(5WN)(link is external) for the list of filenames and their corresponding numbers.


### ss\_type

> One character code indicating the synset type:

>n    NOUN 

>v    VERB 

>a    ADJECTIVE 

>s    ADJECTIVE SATELLITE 

>r    ADVERB 

### w\_cnt

> Two digit hexadecimal integer indicating the number of words in the synset.

### word

> ASCII form of a word as entered in the synset by the lexicographer, with spaces replaced by underscore characters (_ ). The text of the word is case sensitive, in contrast to its form in the corresponding index.pos file, that contains only lower-case forms.

### lex_id

> One digit hexadecimal integer that, when appended onto lemma , uniquely identifies a sense within a lexicographer file. lex\_id numbers usually start with 0 , and are incremented as additional senses of the word are added to the same file, although there is no requirement that the numbers be consecutive or begin with 0 . Note that a value of 0 is the default, and therefore is not present in lexicographer files.

### p\_cnt

> Three digit decimal integer indicating the number of pointers from this synset to other synsets. If p_cnt is 000 the synset has no pointers.

### ptr

>A pointer from this synset to another. ptr is of the form:
>`pointer_symbol  synset_offset  pos  source/target` 
> where synset\_offset is the byte offset of the target synset in the data file corresponding to pos .

> The source/target field distinguishes lexical and semantic pointers. It is a four byte field, containing two two-digit hexadecimal integers. The first two digits indicates the word number in the current (source) synset, the last two digits indicate the word number in the target synset. A value of 0000 means that pointer\_symbol represents a semantic relation between the current (source) synset and the target synset indicated by synset\_offset .

> A lexical relation between two words in different synsets is represented by non-zero values in the source and target word numbers. The first and last two bytes of this field indicate the word numbers in the source and target synsets, respectively, between which the relation holds. Word numbers are assigned to the word fields in a synset, from left to right, beginning with 1 .

>See wninput(5WN) for a list of pointer\_symbol s, and semantic and lexical pointer classifications.

### frames

>In data.verb only, a list of numbers corresponding to the generic verb sentence frames for word s in the synset. frames is of the form:
> `f_cnt   +   f_num  w_num  [ +   f_num  w_num...]` 

>where f\_cnt a two digit decimal integer indicating the number of generic frames listed, f\_num is a two digit decimal integer frame number, and w\_num is a two digit hexadecimal integer indicating the word in the synset that the frame applies to. As with pointers, if this number is 00 , f\_num applies to all word s in the synset. If non-zero, it is applicable only to the word indicated. Word numbers are assigned as described for pointers. Each f\_num  w\_num pair is preceded by a + . See wninput(5WN) for the text of the generic sentence frames.

### gloss

>Each synset contains a gloss. A gloss is represented as a vertical bar (| ), followed by a text string that continues until the end of the line. The gloss may contain a definition, one or more example sentences, or both.



### Sense Numbers
**IMPORTANT**

> Senses in WordNet are generally ordered from most to least frequently used, with the most common sense numbered 1 . Frequency of use is determined by the number of times a sense is tagged in the various semantic concordance texts. Senses that are not semantically tagged follow the ordered senses. The tagsense_cnt field for each entry in the index.pos files indicates how many of the senses in the list have been tagged.

Elsewhere, the most frequent sense is given as sense 0. The numbering referred to here is possibly only consistent within a single file. data.verb contains breathe 3 several times.


> The cntlist(5WN) file provided with the database lists the number of times each sense is tagged in the semantic concordances. The data from cntlist is used by grind(1WN) to order the senses of each word. **When the index .pos files are generated, the synset_offset s are output in sense number order, with sense 1 first in the list.** Senses with the same number of semantic tags are assigned unique but consecutive sense numbers. The WordNet OVERVIEW search displays all senses of the specified word, in all syntactic categories, and indicates which of the senses are represented in the semantically tagged texts.

My emphasis.

> Exception List File Format

> Exception lists are alphabetized lists of inflected forms of words and their base forms. The first field of each line is an inflected form, followed by a space separated list of one or more base forms of the word. There is one exception list file for each syntactic category.

> Note that the noun and verb exception lists were automatically generated from a machine-readable dictionary, and contain many words that are not in WordNet. Also, for many of the inflected forms, base forms could be easily derived using the standard rules of detachment programmed into Morphy (See morph(link is external)(7WN)(link is external) ). These anomalies are allowed to remain in the exception list files, as they do no harm.

Source: https://wordnet.princeton.edu/documentation/wndb5wn
 

### References to lexical files

>29	verb.body	verbs of grooming, dressing and bodily care

>30	verb.change	verbs of size, temperature change, intensifying, etc.

>31	verb.cognition	verbs of thinking, judging, analyzing, doubting

>32	verb.communication	verbs of telling, asking, ordering, singing

>33	verb.competition	verbs of fighting, athletic activities

>34	verb.consumption	verbs of eating and drinking

>35	verb.contact	verbs of touching, hitting, tying, digging

>36	verb.creation	verbs of sewing, baking, painting, performing

>37	verb.emotion	verbs of feeling

>38	verb.motion	verbs of walking, flying, swimming

>39	verb.perception	verbs of seeing, hearing, feeling

>40	verb.possession	verbs of buying, selling, owning

>41	verb.social	verbs of political and social activities and events

>42	verb.stative	verbs of being, having, spatial relations

>43	verb.weather	verbs of raining, snowing, thawing, thundering

Source: https://wordnet.princeton.edu/documentation/lexnames5wn



## Further files

>verb.exc contains al verb forms and lemmatises them

https://wordnet.princeton.edu/documentation/wndb5wn


