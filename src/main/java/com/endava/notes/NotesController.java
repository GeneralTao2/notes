package com.endava.notes;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.stream.StreamSupport;

@RestController
@RequiredArgsConstructor
@Slf4j
public class NotesController {

    private final NoteRepository noteRepository;

    @GetMapping("/")
    public String welcome() {
        log.info("Welcome");
        return "Welcome to Notes";
    }

    @GetMapping("/notes")
    public String getNotes() {
        log.info("Return notes");
        final Iterable<Note> notes = noteRepository.findAll();
        return StreamSupport.stream(notes.spliterator(), false)
                .map(Note::getNoteMessage)
                .toList()
                .toString();
    }

    @GetMapping("/notes/{noteMessage}")
    public String addNote(@PathVariable String noteMessage) {
        log.info("Add a note");
        final Note note = Note.builder()
                .noteMessage(noteMessage)
                .build();
        noteRepository.save(note);
        return getNotes();
    }
}
